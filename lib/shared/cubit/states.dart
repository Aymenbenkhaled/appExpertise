abstract class AppStates {}

class AppInitialState extends AppStates{}

class AppChangePswVisibilityState extends AppStates{}

class AppAuthLoadingState extends AppStates{}

class AppAuthSuccessState extends AppStates{}

class AppAuthErrorState extends AppStates{}

class AppFetchContactState extends AppStates{}

class AppCreateContactState extends AppStates{}

class AppUpdateContactState extends AppStates{}

class AppChageBottomSheetState extends AppStates{}

class AppGetSearchLoadingState extends AppStates{}

class AppGetSearchSuccessState extends AppStates{}

class AppGetSearchErrorState extends AppStates{}

class AppCreateDbState extends AppStates{}

class AppInsertToDbState extends AppStates{}

class AppLoadingState extends AppStates{}

class AppGetFromDbState extends AppStates{}

class AppUpdateDataFromDbState extends AppStates{}

class AppDeleteDataFromDbState extends AppStates{}

class AppSyncDataFromLocalDbState extends AppStates{}