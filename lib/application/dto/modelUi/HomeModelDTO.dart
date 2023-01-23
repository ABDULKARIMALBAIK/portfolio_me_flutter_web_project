import 'package:portfolio_me/application/dto/modelLocal/home/CertificateItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ContactItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/Projectitem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/ServiceItem.dart';
import 'package:portfolio_me/application/dto/modelLocal/home/SkillItem.dart';

class HomeModelDTO {

  //Vars

  //Lists
  List<String> headerListData = [];
  List<String> aboutListData = [];
  List<CertificateItem> certificateData = [];
  List<ServiceItem> servicesData = [];
  List<SkillItem> skillsData = [];
  List<ProjectItem> projectsData = [];
  List<ContactItem> contactData = [];
}