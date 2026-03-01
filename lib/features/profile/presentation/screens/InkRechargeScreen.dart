import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portone_flutter/iamport_payment.dart';
import 'package:portone_flutter/model/payment_data.dart';
import '../../../../app/presentation/notifier/user_notifier.dart';
import '../../domain/usecases/profile_usecase_provider.dart';
class InkRechargeScreen extends ConsumerWidget {
  const InkRechargeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('잉크 충전소')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCoinItem(context, ref, coins: 100, price: 1000, name: '잉크 한 줌'),
          _buildCoinItem(context, ref, coins: 500, price: 4500, name: '잉크 보따리', isBest: true),
          _buildCoinItem(context, ref, coins: 1000, price: 8000, name: '잉크 드럼통'),
        ],
      ),
    );
  }

  Widget _buildCoinItem(BuildContext context, WidgetRef ref,
      {required int coins, required int price, required String name, bool isBest = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isBest ? 4 : 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isBest ? const BorderSide(color: Colors.blue, width: 2) : BorderSide.none),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: const Icon(Icons.water_drop, color: Colors.blue, size: 32),
        title: Text('$coins 잉크', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(name),
        trailing: FilledButton(
          onPressed: () => _startPayment(context, ref, price, name),
          style: isBest ? null : FilledButton.styleFrom(backgroundColor: Colors.grey.shade800),
          child: Text('₩ $price'),
        ),
      ),
    );
  }

  void _startPayment(BuildContext context, WidgetRef ref, int price, String itemName) {
    // 1. .env에서 가맹점 식별코드 가져오기 (없으면 하드코딩된 테스트 값)
    // 기존 iamport_flutter와 똑같이 'userCode'를 씁니다.
    final userCode = dotenv.env['PORTONE_USER_CODE'] ?? 'imp00000000';

    final merchantUid = 'mid_${DateTime.now().millisecondsSinceEpoch}';
    final user = ref.read(userNotifierProvider);

    // 2. 결제 화면으로 이동 (IamportPayment 위젯 사용)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IamportPayment(
          appBar: AppBar(title: const Text('결제하기')),
          initialChild: Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          ),
          userCode: userCode, // ✅ 가맹점 식별코드
          data: PaymentData(
            pg: 'html5_inicis', // or 'kakaopay', 'paypal'
            payMethod: 'card',
            name: itemName,
            merchantUid: merchantUid,
            amount: price,
            buyerName: user?.nickname ?? 'Guest',
            buyerEmail: user?.email ?? '',
            appScheme: 'mindcanvas',
            buyerTel: '', // iOS 필수
          ),
          // 3. 콜백 처리
          callback: (Map<String, String> result) {
            Navigator.pop(context); // 결제창 닫기

            if (result['success'] == 'true') {
              // 성공 시 imp_uid가 넘어옵니다.
              final portoneId = result['imp_uid'] ?? '';
              _verifyOnServer(context, ref, merchantUid, portoneId);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('결제 실패: ${result['error_msg']}')),
              );
            }
          },
        ),
      ),
    );
  }

  // 서버 검증 (기존 로직 유지)
  Future<void> _verifyOnServer(
      BuildContext context, WidgetRef ref, String merchantUid, String portoneId) async {

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    final result = await ref.read(profileUseCaseProvider).verifyPayment(merchantUid, portoneId);

    if (context.mounted) Navigator.pop(context);

    result.fold(
      onSuccess: (_) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('충전 완료!'), backgroundColor: Colors.blue),
        );
        await ref.read(userNotifierProvider.notifier).refreshProfile();
        if (context.mounted) Navigator.pop(context);
      },
      onFailure: (msg, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $msg'), backgroundColor: Colors.red),
        );
      },
    );
  }
}