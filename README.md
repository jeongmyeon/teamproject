레시피 기반 커머스 플랫폼
**벤치마킹 페이지 / 참고 페이지**
  - 요리를 즐겁게 ~ 만개의 레시피
  - mango-recipe-project

프로젝트 목표 
실제 사용자가 직관적으로 이용할 수 있는 플랫폼을 목표로 하며, 사용자 맞춤형 추천, 커뮤니티 활성화, 외부 쇼핑몰 연계를 통해 상업적 가치 창출

이정면(본인)

1. 레시피 목록
    - 검색 기능
        - 요리명 검색
        - 냉장고 털이: 냉장고에 있는 재료들을 입력하면 가장 활용도 높은 레시피 추천(매칭 알고리즘).
        - 검색(매칭 알고리즘) 말고 이렇게 재료 자체를 먼저 나열해두고 클릭하면 해당 재료를 사용한 레시피를 제공해주는건?
    - 셰프(사용자명), 요리 시간 등 간단한 정보 제공.
    - 인기 요리순, 최신 등록 요리순, 테마별(저속노화, 제철 요리 등) → 카테고리 나누기.. 
    - 날씨 api 사용
    - 더보기 버튼 
    - 이미지, 레시피명, 걸린 시간, 간단한 설명, 관심버튼, 레시피, 재료
    - 
2. 레시피 상세보기
- 레시피 상세 페이지 (레시피.. 나열..)
- 관심 버튼
- 재료 구매 가능: 레시피 페이지에서 구매 가능한 재료의 링크를 제휴된 판매 쇼핑몰로 연결. 또는 식재료의 최저가 제공(쿠팡 api)
    - 쿠팡 파트너스 api
- 리뷰란 (모든 사람이 작성, 본인 댓글만 수정, 삭제 가능...)

3. 날씨에 따른 요리 추천 : 날씨 api
     - 사용 로직
      useEffect(() => {
          const fetchWeather = async () => {
          try {
          const now = new Date();
          const year = now.getFullYear();
          const month = String(now.getMonth() + 1).padStart(2, '0');
          const date = String(now.getDate()).padStart(2, '0');
          const hours = String(now.getHours()).padStart(2, '0');
          const minutes = '00';
          const response = await axios.get('http://localhost:8080/api/weather', {
            params: {
              baseDate: `${year}${month}${date}`,
              baseTime: `${hours}${minutes}`,
              nx: 60,
              ny: 127,
            },
            responseType: 'text'
          });
          const parser = new DOMParser();
          const xmlDoc = parser.parseFromString(response.data, 'text/xml');
          const items = xmlDoc.getElementsByTagName('item');
          const weatherData = {};
          for (let i = 0; i < items.length; i++) {
            const category = items[i].getElementsByTagName('category')[0].textContent;
            const value = items[i].getElementsByTagName('obsrValue')[0].textContent;
            if (category === 'T1H') {
              weatherData.temperature = `${value}°C`;
            } else if (category === 'PTY') {
              weatherData.precipitation = value;
            }
          }
          if (weatherData.precipitation === '0') {
            weatherData.precipitation = '맑음';
          } else if (weatherData.precipitation === '1') {
            weatherData.precipitation = '비';
          } else if (weatherData.precipitation === '2') {
            weatherData.precipitation = '흐림';
          } else if (weatherData.precipitation === '3') {
            weatherData.precipitation = '눈';
          }
          setWeather(weatherData);
          setError(null);
          const recipeResponse = await axios.get('http://localhost:8080/api/weather/recipe', {
            params: { precipitation: weatherData.precipitation }
          });
          setRecipes(recipeResponse.data);    
          const popularResponse = await axios.get('http://localhost:8080/api/main/popular');
          setPopularRecipes(popularResponse.data);
          const latestResponse = await axios.get('http://localhost:8080/api/main/recent');
          setLatestRecipes(latestResponse.data);
          const token = localStorage.getItem("token");
          if (token) {
            const response = await axios.get('http://localhost:8080/api/main/recommend', {
              headers: {
                Authorization: `Bearer ${token}`
              }
            });
            setTypeRecipes(response.data);
          }

        } catch (error) {
          setError("날씨 정보를 가져오는 데 실패했습니다.", error);
        }
      };
      fetchWeather();
    }, []);

    const renderWeatherIcon = (precipitation) => {
      switch (precipitation) {
        case '맑음':
          return '☀️';
        case '비':
          return '🌧️';
        case '흐림':
          return '☁️';
        case '눈':
          return '❄️';
        default:
          return null;
      }
    };
   1️⃣ **Spring Boot에서 기상청 API 호출 → 날씨 코드(`weatherData`) 변환!**        
   2️⃣ **컨트롤러에서 `weatherData`를 기반으로 추천 레시피 조회!**
   3️⃣ **React에서 `/api/weather` 호출해서 받아오기!**
   ✅ **이제 날씨에 맞는 레시피 추천 완성! 🚀**

김동하(팀원1)

1. 관리자 페이지
    - 회원 관리: 회원 목록 조회 및 검색
    - 레시피 관리: 레시피 목록, 추가(upload 경로//), 수정, 삭제 가능.
        - 검색
        - 레시피 추가할 때 글 작성 폼이 이렇게 구성되어야 할까요? 아니면 다른 방안이 있을까요?
        - 통계: 레시피 조회수, 좋아요 수, 리뷰 순으로 차트 제공
     
2. 로그인 / 회원가입 페이지
    - 유효성 검사를 통한 로그인/회원가입
  
3. 마이페이지
    - 회원 정보 관리 페이지: 개인 정보 수정 가능
    - 내 활동 페이지: 내 활동 기록 확인 가능
        - 내가 올린 게시판 목록 → 클릭하면 해당 상세보기 페이지 이동**
        - 관심 목록: 저장한 레시피 목록.
        - 카드 형식으로 나열 5열
          
4. 알림 페이지: 이벤트, 레시피 리뷰 등 알림 확인
    - 알림 구현 단계
        - 첫 번째: 간단한 버튼을 눌러 알림 목록을 가져오는 기능
        - 두 번째: 알림을 읽음 처리하는 기능
        - 세 번째: 알림 개수 표시 기능 추가
          
5. 타로카드 레시피 추천 → 메인페이지 배너로 연결 예정
    - 타로를 통한 레시피 추천.

김륜하(팀원2)

1. 메인페이지
    - 헤더, 푸터
    - 베스트 레시피: 가장 많은 리뷰가 작성된 레시피.   
    - 레시피 추천: 로그인 시, 사용자 관심 목록에 따라 카테고리(양식, 일식, 분식..)별 레시피 추천.
      
2. 챗봇 페이지
    - 챗봇의 캐릭터 구현 → 쿡쿡이(cook) / 토끼
    - 키워드를 입력하면 레시피 추천을 받을 수 있는 챗봇

3. 커뮤니티
    - 요리 고민 & 질문 게시판: 사용자들 간의 질문과 답변.
        - 웹 에디터 api https://summernote.org/
        - 목록, 검색, 페이징
        - 상세보기
            - 댓글, 수정, 삭제
    - 지역 기반 요리 모임: 지역별 요리 모임 생성, 참여 신청 및 지도 API를 활용한 위치 정보 제공
        - 테이블x, 카드형식 디자인
        - 모임 추가 버튼
            - 모임 제목, 생성자, 장소, 시간, 목적 등등 작성해야 함
        - 상세보기
            - 모임 장소 지도 api를 통해서 보여줌
            - 모임 참여 신청 버튼 → 모임 생성자에게 웹 알림 전송
        - 더보기 버튼
    - 레시피 공모전: 우수 레시피(목록 자체도 좋아요 순 배열) 를 선정하여 관리자가 공식 레시피로 등록
        - 카드 형식 디자인 (그 달에 올라온 게시글만 보임)
        - 더보기 버튼
        - 좋아요, 싫어요 버튼 추가하고, 좋아요 순으로 목록 나열
        - 레시피 추가 버튼 → 레시피 생성 가능
