class HomeIntent{

  HomeIntent();

  factory HomeIntent.fetchHeaderData() = FetchHeaderData;
  factory HomeIntent.fetchAboutData() = FetchAboutData;
  factory HomeIntent.fetchCertificateData() = FetchCertificateData;
  factory HomeIntent.fetchServicesData() = FetchServicesData;
  factory HomeIntent.fetchSkillsData() = FetchSkillsData;
  factory HomeIntent.fetchProjectsData() = FetchProjectsData;
  factory HomeIntent.fetchContactData() = FetchContactData;

}


class FetchHeaderData extends HomeIntent {
  FetchHeaderData();
}

class FetchAboutData extends HomeIntent {
  FetchAboutData();
}

class FetchCertificateData extends HomeIntent {
  FetchCertificateData();
}

class FetchServicesData extends HomeIntent {
  FetchServicesData();
}

class FetchSkillsData extends HomeIntent {
  FetchSkillsData();
}

class FetchProjectsData extends HomeIntent {
  FetchProjectsData();
}

class FetchContactData extends HomeIntent {
  FetchContactData();
}