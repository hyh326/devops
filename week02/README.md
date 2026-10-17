# 2주차

## 오늘 배운 내용

- 가상화: 베어메탈은 하드웨어 위에 OS를 직접 설치, 하이퍼바이저는 VM마다 OS를 따로 올림, 컨테이너는 호스트 OS 커널을 공유해서 가벼움
- WSL2: Windows 안에서 Ubuntu 리눅스를 쓰는 환경
- 리눅스 기본 명령어: 파일과 폴더 만들기, 이동, 복사, 삭제, 권한 변경
- Git 버전 관리: 커밋으로 기록하고, 이전 버전으로 이동하고, 브랜치로 갈래 나누기
- GitHub: 로컬 커밋을 `git push`로 원격 저장소에 올리기

## 새로 배운 명령어

```bash
# 리눅스
pwd ls -l -a cd mkdir rmdir touch cp mv rm
echo "내용" > 파일    # 덮어쓰기
echo "내용" >> 파일   # 끝에 이어붙이기
chmod +x 파일
history
!!

# Git
git config --global user.name "이름"
git add / git commit -m "메시지" / git log --oneline
git switch -d <해시>   # 이전 커밋 보기
git switch -c <브랜치>  # 브랜치 만들고 이동
git diff <A> <B>
git push
```
