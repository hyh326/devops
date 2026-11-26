# 6주차 - Dockerfile과 ghcr.io 배포

방명록(Flask) 앱을 Dockerfile로 이미지로 만들어 ghcr.io에 올렸다. 빌드 캐시가 어떻게 동작하는지, 설정을 어디에 넣을 수 있는지도 확인했다.

## 1. 내 이미지 주소
- ghcr.io/hyh326/guestbook:v1
- ghcr.io/hyh326/guestbook:v2
- 주소 형식은 `ghcr.io/<GitHub 사용자>/<이미지 이름>:<태그>`이다.

## 2. Dockerfile 각 줄이 하는 일
- FROM python:3.12-slim: 파이썬이 설치된 가벼운 이미지에서 시작
- WORKDIR /app: 컨테이너 안의 작업 폴더 지정
- COPY requirements.txt . / RUN pip install: 의존성만 먼저 설치해서 캐시를 활용
- COPY . .: 앱 코드 복사
- RUN useradd / USER appuser: root가 아닌 사용자로 실행
- ENV: 기본 제목과 색 설정을 이미지에 고정
- EXPOSE 5000: 앱이 5000번 포트를 사용함을 표시
- CMD ["python", "app.py"]: 컨테이너 시작 시 실행할 명령

## 3. 빌드 캐시 동작 로그 (CACHED)
`CACHED`는 그 단계를 새로 실행하지 않고 이전 빌드 결과를 재사용했다는 뜻이다.

~~~text
#4 [1/6] FROM docker.io/library/python:3.12-slim@sha256:05cda9777409a9c3ffddd94a4c476b79f0769a0b4857f0c7ed9226b6800b0d6f
#6 [4/6] RUN pip install --no-cache-dir -r requirements.txt
#6 CACHED
#7 [2/6] WORKDIR /app
#7 CACHED
#8 [5/6] COPY . .
#8 CACHED
#9 [3/6] COPY requirements.txt .
#9 CACHED
#10 [6/6] RUN useradd -m appuser
#10 CACHED
~~~

requirements.txt만 먼저 복사해서 pip install을 하고 앱 코드는 그 뒤에 복사한다. 코드만 고치면 `COPY . .`부터 다시 실행되고, 오래 걸리는 pip install은 캐시를 쓴다.

## 4. 설정을 넣는 세 가지 방법
- app.py 기본값: 코드에서 확정, 바꾸려면 코드 수정 후 재빌드
- Dockerfile ENV: 이미지 빌드 시점에 확정, 바꾸려면 재빌드
- docker run -e: 컨테이너 실행 시점에 확정, 컨테이너만 다시 실행
- 우선순위: app.py 기본값 < Dockerfile ENV < docker run -e

## 5. 알게 된 점
- 이미지는 레이어(Dockerfile 한 줄 = 한 층)로 쌓이고, 앞 단계가 바뀌지 않으면 CACHED로 재사용한다. 그래서 자주 바뀌는 앱 코드는 뒤쪽에 둔다.
- root가 아닌 appuser로 실행하면 컨테이너 안이 뚫려도 할 수 있는 일이 제한된다.
- 같은 설정이라도 넣는 위치에 따라 바꾸는 시점이 다르다. 실행할 때마다 바꿀 값은 `-e`로, 거의 안 바뀌는 기본값은 ENV로 넣는 게 편하다.
- 이미지를 ghcr.io에 올려두면 다른 환경에서도 같은 이미지를 받아 쓸 수 있다. 9주차 쿠버네티스에서도 이 이미지를 그대로 사용했다.
