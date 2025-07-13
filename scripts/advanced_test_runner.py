# ========================================
# Mind Canvas - 고급 테스트 스크립트 (Python)
# 병렬 실행, 성능 모니터링, 상세 리포트 제공
# ========================================

import os
import sys
import subprocess
import time
import json
import argparse
from pathlib import Path
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Dict, List, Optional, Tuple

class TestRunner:
    """고급 테스트 실행기"""
    
    def __init__(self):
        self.project_root = Path.cwd()
        self.test_results = {}
        self.start_time = None
        self.end_time = None
        
    def log(self, message: str, level: str = "INFO") -> None:
        """컬러 로그 출력"""
        colors = {
            "INFO": "\033[36m",      # Cyan
            "SUCCESS": "\033[32m",   # Green
            "ERROR": "\033[31m",     # Red
            "WARNING": "\033[33m",   # Yellow
            "RESET": "\033[0m"       # Reset
        }
        
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        color = colors.get(level, colors["INFO"])
        reset = colors["RESET"]
        
        print(f"{color}[{timestamp}] [{level}] {message}{reset}")
    
    def run_command(self, command: List[str], timeout: int = 300) -> Tuple[int, str, str]:
        """명령어 실행"""
        try:
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                timeout=timeout,
                cwd=self.project_root
            )
            return result.returncode, result.stdout, result.stderr
        except subprocess.TimeoutExpired:
            return 1, "", f"Command timed out after {timeout} seconds"
        except Exception as e:
            return 1, "", str(e)
    
    def check_flutter_environment(self) -> bool:
        """Flutter 환경 체크"""
        self.log("Flutter 환경 확인 중...")
        
        # Flutter 설치 확인
        code, stdout, stderr = self.run_command(["flutter", "--version"])
        if code != 0:
            self.log("Flutter가 설치되지 않았거나 PATH에 없습니다.", "ERROR")
            return False
        
        # 프로젝트 유효성 확인
        if not (self.project_root / "pubspec.yaml").exists():
            self.log("Flutter 프로젝트가 아닙니다.", "ERROR")
            return False
        
        # 의존성 확인
        self.log("패키지 의존성 확인 중...")
        code, stdout, stderr = self.run_command(["flutter", "pub", "get"])
        if code != 0:
            self.log(f"패키지 설치 실패: {stderr}", "ERROR")
            return False
        
        self.log("Flutter 환경 확인 완료!", "SUCCESS")
        return True
    
    def clean_project(self) -> bool:
        """프로젝트 정리"""
        self.log("프로젝트 정리 중...")
        
        # Flutter clean
        code, stdout, stderr = self.run_command(["flutter", "clean"])
        if code != 0:
            self.log(f"Flutter clean 실패: {stderr}", "ERROR")
            return False
        
        # 패키지 재설치
        code, stdout, stderr = self.run_command(["flutter", "pub", "get"])
        if code != 0:
            self.log(f"패키지 재설치 실패: {stderr}", "ERROR")
            return False
        
        self.log("프로젝트 정리 완료!", "SUCCESS")
        return True
    
    def run_test_category(self, category: str, parallel: bool = False) -> Dict:
        """테스트 카테고리 실행"""
        test_paths = {
            "unit": "test/unit/",
            "widget": "test/widget/",
            "integration": "test/integration/"
        }
        
        if category not in test_paths:
            return {"success": False, "error": f"Unknown test category: {category}"}
        
        test_path = test_paths[category]
        
        # 테스트 파일 존재 확인
        full_path = self.project_root / test_path
        if not full_path.exists():
            return {
                "success": False, 
                "error": f"Test directory not found: {test_path}"
            }
        
        self.log(f"🧪 {category.title()} 테스트 실행 중...")
        start_time = time.time()
        
        # Flutter 테스트 명령어
        command = ["flutter", "test", test_path, "--reporter=json"]
        if parallel:
            command.extend(["--concurrency", "4"])
        
        code, stdout, stderr = self.run_command(command, timeout=600)
        end_time = time.time()
        duration = end_time - start_time
        
        # 결과 파싱
        test_count = 0
        passed_count = 0
        failed_count = 0
        
        if stdout:
            for line in stdout.split('\n'):
                if line.strip():
                    try:
                        data = json.loads(line)
                        if data.get('type') == 'testDone':
                            test_count += 1
                            if data.get('result') == 'success':
                                passed_count += 1
                            else:
                                failed_count += 1
                    except json.JSONDecodeError:
                        continue
        
        result = {
            "success": code == 0,
            "duration": duration,
            "test_count": test_count,
            "passed": passed_count,
            "failed": failed_count,
            "stdout": stdout,
            "stderr": stderr
        }
        
        if result["success"]:
            self.log(f"✅ {category.title()} 테스트 완료! "
                    f"({passed_count}/{test_count} 통과, {duration:.2f}초)", "SUCCESS")
        else:
            self.log(f"❌ {category.title()} 테스트 실패! "
                    f"({failed_count} 실패, {duration:.2f}초)", "ERROR")
        
        return result
    
    def run_coverage_test(self) -> Dict:
        """커버리지 테스트 실행"""
        self.log("📊 코드 커버리지 테스트 실행 중...")
        start_time = time.time()
        
        command = ["flutter", "test", "--coverage", "--reporter=json"]
        code, stdout, stderr = self.run_command(command, timeout=900)
        
        end_time = time.time()
        duration = end_time - start_time
        
        result = {
            "success": code == 0,
            "duration": duration,
            "stdout": stdout,
            "stderr": stderr
        }
        
        if result["success"]:
            # 커버리지 파일 확인
            coverage_file = self.project_root / "coverage" / "lcov.info"
            if coverage_file.exists():
                self.log(f"📈 커버리지 파일 생성됨: {coverage_file}", "SUCCESS")
                
                # 커버리지 통계 추출 (간단한 파싱)
                try:
                    with open(coverage_file, 'r') as f:
                        content = f.read()
                        lines = content.count('LF:')
                        hit_lines = content.count('LH:')
                        coverage_percent = (hit_lines / lines * 100) if lines > 0 else 0
                        
                        result["coverage_percent"] = coverage_percent
                        result["total_lines"] = lines
                        result["covered_lines"] = hit_lines
                        
                        self.log(f"📊 커버리지: {coverage_percent:.1f}% "
                                f"({hit_lines}/{lines} 라인)", "INFO")
                except Exception as e:
                    self.log(f"커버리지 파싱 오류: {e}", "WARNING")
            
            self.log(f"✅ 커버리지 테스트 완료! ({duration:.2f}초)", "SUCCESS")
        else:
            self.log(f"❌ 커버리지 테스트 실패! ({duration:.2f}초)", "ERROR")
        
        return result
    
    def run_parallel_tests(self) -> Dict:
        """병렬 테스트 실행"""
        self.log("🚀 병렬 테스트 실행 중...")
        
        categories = ["unit", "widget", "integration"]
        results = {}
        
        with ThreadPoolExecutor(max_workers=3) as executor:
            # 테스트 제출
            future_to_category = {
                executor.submit(self.run_test_category, category, True): category
                for category in categories
            }
            
            # 결과 수집
            for future in as_completed(future_to_category):
                category = future_to_category[future]
                try:
                    result = future.result()
                    results[category] = result
                except Exception as e:
                    results[category] = {
                        "success": False,
                        "error": str(e)
                    }
        
        return results
    
    def generate_report(self) -> None:
        """테스트 리포트 생성"""
        self.log("📄 테스트 리포트 생성 중...")
        
        report = {
            "timestamp": datetime.now().isoformat(),
            "duration": (self.end_time - self.start_time) if self.start_time and self.end_time else 0,
            "results": self.test_results
        }
        
        # JSON 리포트
        report_file = self.project_root / "test_report.json"
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        
        self.log(f"📊 리포트 생성됨: {report_file}", "SUCCESS")
        
        # 간단한 요약 출력
        self.print_summary()
    
    def print_summary(self) -> None:
        """테스트 요약 출력"""
        print("\n" + "="*50)
        print("🎯 테스트 실행 요약")
        print("="*50)
        
        total_tests = 0
        total_passed = 0
        total_failed = 0
        total_duration = 0
        
        for category, result in self.test_results.items():
            if isinstance(result, dict) and "test_count" in result:
                print(f"\n📋 {category.title()} 테스트:")
                print(f"   ✅ 통과: {result.get('passed', 0)}")
                print(f"   ❌ 실패: {result.get('failed', 0)}")
                print(f"   ⏱️  소요시간: {result.get('duration', 0):.2f}초")
                
                total_tests += result.get('test_count', 0)
                total_passed += result.get('passed', 0)
                total_failed += result.get('failed', 0)
                total_duration += result.get('duration', 0)
        
        print(f"\n🏆 전체 결과:")
        print(f"   📊 총 테스트: {total_tests}")
        print(f"   ✅ 총 통과: {total_passed}")
        print(f"   ❌ 총 실패: {total_failed}")
        print(f"   ⏱️  총 소요시간: {total_duration:.2f}초")
        
        if total_tests > 0:
            success_rate = (total_passed / total_tests) * 100
            print(f"   📈 성공률: {success_rate:.1f}%")
        
        print("="*50)
    
    def run_tests(self, test_type: str, clean: bool = False, parallel: bool = False) -> bool:
        """메인 테스트 실행 함수"""
        self.start_time = time.time()
        
        # 환경 체크
        if not self.check_flutter_environment():
            return False
        
        # 정리 옵션
        if clean:
            if not self.clean_project():
                return False
        
        # 테스트 실행
        success = True
        
        if test_type == "all":
            if parallel:
                self.test_results = self.run_parallel_tests()
            else:
                for category in ["unit", "widget", "integration"]:
                    result = self.run_test_category(category)
                    self.test_results[category] = result
                    if not result["success"]:
                        success = False
        
        elif test_type == "coverage":
            result = self.run_coverage_test()
            self.test_results["coverage"] = result
            success = result["success"]
        
        elif test_type in ["unit", "widget", "integration"]:
            result = self.run_test_category(test_type)
            self.test_results[test_type] = result
            success = result["success"]
        
        else:
            self.log(f"알 수 없는 테스트 타입: {test_type}", "ERROR")
            return False
        
        self.end_time = time.time()
        
        # 리포트 생성
        self.generate_report()
        
        return success

def main():
    """메인 함수"""
    parser = argparse.ArgumentParser(description="Mind Canvas 고급 테스트 실행기")
    parser.add_argument(
        "test_type",
        choices=["unit", "widget", "integration", "all", "coverage"],
        help="실행할 테스트 타입"
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="테스트 전 프로젝트 정리"
    )
    parser.add_argument(
        "--parallel",
        action="store_true",
        help="병렬 테스트 실행 (all 타입에서만)"
    )
    
    args = parser.parse_args()
    
    print("🎨 Mind Canvas - 고급 테스트 실행기")
    print("="*50)
    
    runner = TestRunner()
    success = runner.run_tests(args.test_type, args.clean, args.parallel)
    
    if success:
        print("\n🎉 모든 테스트가 성공적으로 완료되었습니다!")
        sys.exit(0)
    else:
        print("\n💥 일부 테스트가 실패했습니다!")
        sys.exit(1)

if __name__ == "__main__":
    main()
