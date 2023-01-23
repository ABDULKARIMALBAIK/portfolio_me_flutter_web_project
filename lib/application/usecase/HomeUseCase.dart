import 'package:portfolio_me/application/dto/modelLocal/home/CertificateItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ContactItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/Projectitem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ServiceItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/SkillItem.dart';
import 'package:portfolio_me/data/localRepo/HomeLocalRepository.dart';

class HomeUseCase {

  //Repository
  late HomeLocalRepository homeLocalRepository;

  //Other processors: share data , save file and open link etc...


  //Other methods to check and validate data (like to sign in and sign up data request)



  HomeUseCase(){
    homeLocalRepository = HomeLocalRepository();
  }


  List<String> fetchHeaderData(){
    return homeLocalRepository.fetchHeaderData();
  }

  List<String> fetchAboutData(){
    return homeLocalRepository.fetchAboutData();
  }

  List<CertificateItem> fetchCertificateData(){
    return homeLocalRepository.fetchCertificateData();
  }

  List<ServiceItem> fetchServicesData(){
    return homeLocalRepository.fetchServicesData();
  }

  List<SkillItem> fetchSkillsData(){
    return homeLocalRepository.fetchSkillsData();
  }

  List<ProjectItem> fetchProjectsData(){
    return homeLocalRepository.fetchProjectsData();
  }

  List<ContactItem> fetchContactData(){
    return homeLocalRepository.fetchContactData();
  }



  //validateDataSignIn(String email , String password){
  //checking the data.......
  //}

}