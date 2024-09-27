//
//  StringLiterals.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

enum StringLiterals {
    enum Root {
        static let home = "홈"
        static let map = "지도"
        static let waiting = "웨이팅"
        static let stamp = "스탬프"
        static let menu = "메뉴"
    }
    
    enum Intro {
        static let infoTitle = "관심있는 학교 축제를 추가해보세요"
        static let infoSubtitle = "관심 학교는 언제든지 수정 가능합니다"
        static let searchPlaceholder = "학교를 검색해보세요"
        static let myFestivalTitle = "나의 관심 축제"
        static let discardAll = "모두 선택 해제"
        static let number = "총 %@개"
        static let complete = "추가 완료"
    }
    
    enum NetworkError {
        static let serverErrorTitle = "서버 문제 발생"
        static let serverErrorMessage = "개발자에게 문의 바랍니다."
        static let networkErrorTitle = "네트워크 문제"
        static let networkErrorMessage = "와이파이나 데이터 접속을 확인해주세요."
        static let confirmError = "확인"
        static let retry = "재시도"
    }
    
    enum Detail {
        static let openLocation = "위치 확인하기"
        static let menuTitle = "메뉴"
        static let noMenuTitle = "등록된 메뉴가 없어요"
        static let noWaitingBooth = "웨이팅을 지원하지 않는 부스입니다"
        static let doWaiting = "웨이팅"
        static let won = "원"
    }
    
    enum Calendar {
        static let month = "월"
        static let day = "일"
    }
    
    enum Home {
        static let festivalTitle = "축제 일정"
        static let noFestivalTitle = "축제 일정 없음"
        static let noFestivalMessage = "오늘은 축제가 열리는 학교가 없어요"
        static let upcomingFestivalTitle = "다가오는 축제 일정"
        static let noUpcomingFestivalTitle = "다가오는 축제 일정 없음"
        static let noUpcomingFestivalMessage = "남은 축제 일정이 없어요"
    }
    
    enum Map {
        static let favoriteBoothTitle = "인기 부스"
        static let searchPlaceholder = "부스/주점을 검색해보세요."
        static let drinkBoothTitle = "주점"
        static let foodBoothTitle = "먹거리"
        static let eventBoothTitle = "이벤트"
        static let generalBoothTitle = "일반"
        static let hospitalBoothTitle = "의무실"
        static let toiletBoothTitle = "화장실"
        static let ranking = "위"
    }
    
    enum Menu {
        static let title = "메뉴"
        static let LikedSchoolTitle = "나의 관심축제"
        static let LikedBoothTitle = "관심부스"
        static let more = "더보기"
        static let noLikedBoothTitle = "관심부스 없음"
        static let noLikedBoothMessage = "지도에서 관심있는 부스를 추가해주세요"
        static let askTitle = "이용문의 (카카오톡 채널)"
        static let operatorModeTitle = "운영자 웹사이트"
        static let instagram = "인스타그램"
        static let appTitle = "UNIFEST"
        static let copyright = "UNIFEST 2024 © ALL RIGHT RESERVED"
        static let TeamTitle = "Team UNIFEST"
        static let locationAuthText = "위치 권한 수정"
        static let cameraAuthText = "카메라 권한 수정"
        static let notificationAuthText = "알림 권한 수정"
        static let developerMail = "개발자에게 메일 보내기"
        static let privacyText = "개인정보 처리방침"
        static let clearApp = "앱 데이터 초기화"
        static let clusterSetting = "지도에서 가까운 부스 묶어보기"
    }
    
    enum Waiting {
        static let title = "웨이팅"
        static let myWaiting = "나의 웨이팅"
        static let noWaitingTitle = "신청한 웨이팅이 없어요"
        static let gotoMapView = "주점/부스 구경하러 가기"
    }
    
    enum URL {
        static let messageChannelLink = "http://pf.kakao.com/_KxaaDG/chat"
        static let operatorModeLink = "https://www.unifest.app/"
        static let instagramLink = "https://www.instagram.com/unifest_2024"
        static let privacyPolicyLink = "https://abiding-hexagon-faa.notion.site/App-c351cc083bc1489e80e974df5136d5b4?pvs=4"
    }
}
