# README

An application to index some of the packages in a CRAN server with package name based search api.

* to run the application start by git clone git@github.com:vikram89813/cranData.git
* `bundle install` inside the project folder.
* setup your database by making necessary changes in `config/database.yml`
* `rake db:migrate`
* you can check the tables in `db/schema.rb`

##### At this point the application is ready 

* from the project folder run `rake seed_package:download`, this will fill the database with the required data.
* we have these packages in the application `["ABCanalysis", "abcADM", "ABACUS", "A3", "abc", "abcdeFBA", "aaSEA", "abbyyR", "abc.data", "ABC.RAP", "ABCoptim", "abe", "abf2", "abcrlda", "abd", "abdiv", "ABHgenotypeR", "abctools", "abcrf", "abjutils", "abind", "AbsFilterGSEA", "ABPS", "abtest", "abstractr", "AbSim", "abn", "ACA", "accrual", "accelerometry", "acc", "AcceptanceSampling", "Ac3net", "accelmissing", "ACD", "acepack", "ace2fastq", "acid", "ACEt", "accrued", "accSDA", "ACDm", "acebayes", "acrt", "AcrossTic", "acm4r", "aCRM", "ACNE", "acmeR", "AcousticNDLCodeR", "acopula", "acnr", "acss", "ACSNMineR", "ACTCD", "ACSWR", "ActiveDriver", "ActFrag", "ActiveDriverWGS", "acs", "acss.data", "Actigraphy", "activity", "AcuityView", "actogrammr", "activPAL", "activityCounts", "actuaryr", "ada", "actuar", "activpalProcessing", "ActivePathways", "adabag", "AdaptFit", "adagio", "AdaptFitOS", "AdapEnetClass", "AdaptGauss", "adamethods", "adapr", "AdaptiveSparsity", "AdaSampling", "adaptivetau", "adaptMT", "adaptiveGPCA", "adaptsmoFMRI", "ADAPTS"]`
* run `rails s` to start the server.
* you can run a search query like `http://localhost:3000/package/aasea` , here package name is `aasea`.

##### I have used MVC architectural paradigm to design the application.
