load('LME.mat');

datanow = data;
datanow.Region = nominal(datanow.Region);
datanow.Sex = nominal(datanow.Sex);
datanow.IndividualID = nominal(datanow.IndividualID);
datanow.Region = reordercats(datanow.Region ,[6,1:5 7:19]);
categories(datanow.Region)

lmeModel_new=fitlme(datanow, 'PositiveResponse ~ Region + Age + Sex + CurrentIntensity +(1|IndividualID)');
anova(lmeModel_new)

fixedEffectsTable = lmeModel_new.Coefficients;

