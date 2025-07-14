# 환율 계산기 어플리케이션 개인 과제

# 폴더링

```
ExchangesApp/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── Models/
│   ├── CoreData/
│   │   ├── CoreDataManager.swift
│   │   ├── CurrencySnapshot+CoreDataClass.swift
│   │   ├── CurrencySnapshot+CoreDataProperties.swift
│   │   ├── FavoriteCurrency+CoreDataClass.swift
│   │   ├── FavoriteCurrency+CoreDataProperties.swift
│   │   ├── LastScreen+CoreDataClass.swift
│   │   ├── LastScreen+CoreDataProperties.swift
│   ├── Currency.swift
│   ├── CurrencyCodeMap.swift
│   ├── CurrencyItem.swift
│   ├── LastScreenType.swift
│   └── TestData.swift
│
├── Protocols/
│   └── ViewModelProtocol.swift
│
├── Resources/
│   ├── Assets.xcassets
│   ├── CurrencyModel.json
│   └── Info.plist
│
├── Scenes/
│   ├── Calculator/
│   │   ├── CalculatorView.swift
│   │   ├── CalculatorViewController.swift
│   │   └── CalculatorViewModel.swift
│   │
│   └── CurrencyList/
│       ├── CurrencyListTableViewCell.swift
│       ├── CurrencyListViewController.swift
│       └── CurrencyListViewModel.swift
│
├── Utils/
│   ├── Extension/
│   │
│   └── Services/
│       ├── AlertFactory.swift
│       ├── DataService.swift
│       └── SymbolMakingService.swift
```


# 각 파일 기능 일람

##  Models
`CoreData`

    - CoreDataManager : CoreData 입출력 함수 관리

    - 이하 CoreData Entity 자동생성 파일

Currency : JSON과 일치하는 디코드 모델

CurrencyCodeMap : 국가명 매핑용 딕셔너리

CurrencyItem : UI에서 사용할 데이터 모델 정보

LastScreenType : 마지막 스크린 정보 보관용 문자열 열거형

TestData : 테스트용 데이터와 최초 실행시 앱크래시 방지용 더미 데이터

## Protocols

ViewModelProtocol : 과제서 제시한 Action State 프로토콜

## Resources

CurrencyModel : 이 어플리케이션용 Data Model

## Scenes
`Calculator`

    - CalculatorView : 계산기 화면의 뷰 요소(고정값)
    
    - CalculatorViewController : 계산기 화면의 뷰 컨트롤러, 제어 + 뷰모델에 바인딩되는 뷰 요소
    
    - CalculatorViewModel : 계산기 화면의 뷰 모델

`CurrencyList`

    - CurrencyListTableViewCell : 테이블 뷰 셀
    
    - CurrencyListViewController : 통화목록 뷰 컨트롤러 + 뷰 요소
    
    - CurrencyListViewModel : 통화목록 뷰 모델

## Utils

`Extension`

    - 현재 구현상으로는 미사용

`Services`

    - AlertFatcory : 에러 창 정의와 JSON 파싱 에러메시지 열거형 보관
    
    - DataService : Alamofire로 JSON 파싱
    
    - SymbolMakingService : 뷰에서 사용할 심볼 데이터를 할당
