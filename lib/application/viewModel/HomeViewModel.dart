import 'package:carousel_slider/carousel_controller.dart';
import 'package:confetti/confetti.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/CertificateItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ContactItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/Projectitem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ServiceItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/SkillItem.dart';
import 'package:portfolio_me/application/dto/modelUi/HomeModelDTO.dart';
import 'package:portfolio_me/application/usecase/HomeUseCase.dart';
import 'package:portfolio_me/presentation/intent/HomeIntent.dart';
import 'package:portfolio_me/presentation/notifier/LanguageProvider.dart';
import 'package:portfolio_me/presentation/notifier/ThemeProvider.dart';
import 'package:portfolio_me/presentation/state/HomeState.dart';
import 'package:portfolio_me/utils/ErrorCodes.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {

  //Providers
  late ThemeProvider themeProvider;
  late LanguageProvider languageProvider;

  //Controllers
  late CarouselController carouselController;
  late ConfettiController confettiController;

  //Model
  late HomeModelDTO modelDTO;

  //UseCase
  late HomeUseCase useCase;

  //Streams
  late BehaviorSubject<HomeIntent> intentStream;
  late BehaviorSubject<HomeState> stateHeaderStream;
  late BehaviorSubject<HomeState> stateAboutStream;
  late BehaviorSubject<HomeState> stateCertificateStream;
  late BehaviorSubject<HomeState> stateServicesStream;
  late BehaviorSubject<HomeState> stateSkillsStream;
  late BehaviorSubject<HomeState> stateProjectsStream;
  late BehaviorSubject<HomeState> stateContactStream;

  HomeViewModel(){

    initStreams();

    modelDTO = HomeModelDTO();
    useCase = HomeUseCase();

    carouselController = CarouselController();
    confettiController  = ConfettiController(duration: Duration(seconds: 2));
  }

  void initStreams() {
    intentStream = BehaviorSubject<HomeIntent>();
    stateHeaderStream = BehaviorSubject<HomeState>();
    stateAboutStream = BehaviorSubject<HomeState>();
    stateCertificateStream =  BehaviorSubject<HomeState>();
    stateServicesStream = BehaviorSubject<HomeState>();
    stateSkillsStream = BehaviorSubject<HomeState>();
    stateProjectsStream = BehaviorSubject<HomeState>();
    stateContactStream = BehaviorSubject<HomeState>();
  }

  void initAppProviders(ThemeProvider themeProvider , LanguageProvider languageProvider){
    this.themeProvider = themeProvider;
    this.languageProvider = languageProvider;
  }

  listen(){

    //print('start listing');
    intentStream.stream.listen((event) {

      HomeIntent intent = event;

      if(intent is FetchHeaderData){
        //print('intent FetchHeaderData');
        handleHeaderDataIntent();
      }
      else if(intent is FetchAboutData){
        //print('intent FetchAboutData');
        handleAboutDataIntent();
      }
      else if(intent is FetchCertificateData){
        //print('intent FetchCertificateData');
        handleCertificateDataIntent();
      }
      else if(intent is FetchServicesData){
        //print('intent FetchServicesData');
        handleServicesDataIntent();
      }
      else if(intent is FetchSkillsData){
        //print('intent FetchSkillsData');
        handleSkillsDataIntent();
      }
      else if(intent is FetchProjectsData){
        //print('intent FetchProjectsData');
        handleProjectsDataIntent();
      }
      else if(intent is FetchContactData){
        ////print('intent FetchContactData');
        handleContactDataIntent();
      }
      else {
        //print('other type');
      }

    });
  }


  //Send intents
  loadHeaderData(){
    intentStream.add(HomeIntent.fetchHeaderData());
  }

  loadAboutData(){
    intentStream.add(HomeIntent.fetchAboutData());
  }

  loadCertificateData(){
    intentStream.add(HomeIntent.fetchCertificateData());
  }

  loadSkillsData(){
    intentStream.add(HomeIntent.fetchSkillsData());
  }

  loadServicesData(){
    intentStream.add(HomeIntent.fetchServicesData());
  }

  loadProjectsData(){
    intentStream.add(HomeIntent.fetchProjectsData());
  }

  loadContactData(){
    intentStream.add(HomeIntent.fetchContactData());
  }



  //Handle Intents
  void handleHeaderDataIntent() {
    stateHeaderStream.add(HomeState.idle());

    stateHeaderStream.add(HomeState.loading());

    try {
      List<String> data = useCase.fetchHeaderData();

      if(data.length <= 0){
        stateHeaderStream.add(HomeState.noData());
      }
      else {
        //Here for network request maybe need more conditions
        modelDTO.headerListData = data;
        stateHeaderStream.add(HomeState.success(modelDTO.headerListData));
      }
    }
    on Exception catch (exception){
      stateHeaderStream.add(HomeState.error('Error happened here', ErrorCodes().ERROR_NO_CODE));
    }
  }

  void handleAboutDataIntent() {

    stateAboutStream.add(HomeState.idle());

    stateAboutStream.add(HomeState.loading());

    try {
      List<String> data = useCase.fetchAboutData();

      if(data.length <= 0){
        stateAboutStream.add(HomeState.noData());
      }
      else {
        //Here for network request maybe need more conditions
        modelDTO.aboutListData = data;
        stateAboutStream.add(HomeState.success(modelDTO.aboutListData));
      }
    }
    on Exception catch (exception){
      stateAboutStream.add(HomeState.error('Error happened here', ErrorCodes().ERROR_NO_CODE));
    }
  }

  void handleCertificateDataIntent() {

    stateCertificateStream.add(HomeState.idle());

    stateCertificateStream.add(HomeState.loading());

    try {
      List<CertificateItem> data = useCase.fetchCertificateData();

      if(data.length <= 0){
        stateCertificateStream.add(HomeState.noData());
      }
      else {
        //Here for network request maybe need more conditions
        modelDTO.certificateData = data;
        stateCertificateStream.add(HomeState.success(modelDTO.certificateData));
      }
    }
    on Exception catch (exception){
      stateCertificateStream.add(HomeState.error('Error happened here', ErrorCodes().ERROR_NO_CODE));
    }
  }

  void handleServicesDataIntent() {

    stateServicesStream.add(HomeState.idle());

    stateServicesStream.add(HomeState.loading());

    try {
      List<ServiceItem> data = useCase.fetchServicesData();

      if(data.length <= 0){
        stateServicesStream.add(HomeState.noData());
      }
      else {
        //Here for network request maybe need more conditions
        modelDTO.servicesData = data;
        stateServicesStream.add(HomeState.success(modelDTO.servicesData));
      }
    }
    on Exception catch (exception){
      stateServicesStream.add(HomeState.error('Error happened here', ErrorCodes().ERROR_NO_CODE));
    }
  }

  void handleSkillsDataIntent() {

    stateSkillsStream.add(HomeState.idle());

    stateSkillsStream.add(HomeState.loading());

    try {
      List<SkillItem> data = useCase.fetchSkillsData();

      if(data.length <= 0){
        stateSkillsStream.add(HomeState.noData());
      }
      else {
        //Here for network request maybe need more conditions
        modelDTO.skillsData = data;
        stateSkillsStream.add(HomeState.success(modelDTO.skillsData));
      }
    }
    on Exception catch (exception){
      stateSkillsStream.add(HomeState.error('Error happened here', ErrorCodes().ERROR_NO_CODE));
    }

  }

  void handleProjectsDataIntent() {

    stateProjectsStream.add(HomeState.idle());

    stateProjectsStream.add(HomeState.loading());

    try {
      List<ProjectItem> data = useCase.fetchProjectsData();

      if(data.length <= 0){
        stateProjectsStream.add(HomeState.noData());
      }
      else {
        //Here for network request maybe need more conditions
        modelDTO.projectsData = data;
        stateProjectsStream.add(HomeState.success(modelDTO.projectsData));
      }
    }
    on Exception catch (exception){
      stateProjectsStream.add(HomeState.error('Error happened here', ErrorCodes().ERROR_NO_CODE));
    }
  }

  void handleContactDataIntent() {

    stateContactStream.add(HomeState.idle());

    stateContactStream.add(HomeState.loading());

    try {
      List<ContactItem> data = useCase.fetchContactData();

      if(data.length <= 0){
        stateContactStream.add(HomeState.noData());
      }
      else {
        //Here for network request maybe need more conditions
        modelDTO.contactData = data;
        stateContactStream.add(HomeState.success(modelDTO.contactData));
      }
    }
    on Exception catch (exception){
      stateContactStream.add(HomeState.error('Error happened here', ErrorCodes().ERROR_NO_CODE));
    }
  }


}
