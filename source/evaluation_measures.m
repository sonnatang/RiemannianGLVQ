function [ measureValue ] = evaluation_measures(Y, predictY,classes, method )
%evaluation_measures-- evaluate the preformance of the prediction according
%to different measurements.
%input: 
%       Y--real output
%       predictY--predicted output
%       method -- measurement metric,including
%                   'RA' -- regular accuracy
%                   'Gmean' -- geometric mean of recall 
%                   'BA' -- balanced accuracy
%                   'CBA' -- class balanced accuracy
%                   'MCC'-- Mathrew correlation coefficients
%                   'KAPPA'--kappa coefficient
% ouput:
%       measureValue: a single number to assess the performance of the
%       prediction according to different evaluation metric.
% author Fengzhen Tang (tangfengzhen@sia.cn)
if ~strcmp('RA',method)
    nClasses = length(classes);
     %%%confusion matrix
    confusionMatrix = zeros(nClasses);
     for ii = 1:length(Y)
         trueC = find(classes==Y(ii));
         preC = find(classes==predictY(ii));
         confusionMatrix(trueC,preC) =  confusionMatrix(trueC,preC) +1;
     end
end
 

 switch method
     case 'confusionMatrix'
         measureValue = confusionMatrix;
     case 'Gmean'
         %%%recall
         R = zeros(nClasses,1);
         for ii = 1:nClasses 
            R(ii) = confusionMatrix(ii,ii)/sum(confusionMatrix(ii,:));
         end
        Gmean = prod(R);
        Gmean = nthroot(Gmean,nClasses);
        measureValue = Gmean;
     case 'BA' %%balanced accuracy
         %%%recall
         R = zeros(nClasses,1);
         for ii = 1:nClasses 
            R(ii) = confusionMatrix(ii,ii)/sum(confusionMatrix(ii,:));
         end
         measureValue = mean(R);
     case 'CBA' %%class balanced accuracy
         CBA = zeros(nClasses,1);
         for ii= 1:nClasses
             sumN = max(sum(confusionMatrix(ii,:)),sum(confusionMatrix(:,ii)));
             CBA(ii) = confusionMatrix(ii,ii)/sumN;
         end
         measureValue = mean(CBA);
     case 'MCC'
          deno = 0;
         for k = 1:nClasses
             for l = 1:nClasses
                 for m = 1:nClasses
                     deno = deno + confusionMatrix(k,k)*confusionMatrix(l,m) -confusionMatrix(k,l)*confusionMatrix(m,k); 
                     
                 end
             end
         end
        numo1 = 0;
        numo2 = 0;
        Ckdot = zeros(nClasses,1);
        Cdotk = zeros(nClasses,1);
        for k = 1:nClasses
            Ckdot(k) =  sum(confusionMatrix(k,:));
            Cdotk(k) =  sum(confusionMatrix(:,k));
        end
        for k = 1:nClasses
            Ckdotnk = Ckdot;
            Ckdotnk(k) = [];
            numo1 = numo1 + Ckdot(k) * sum(Ckdotnk);

            Cdotknk = Cdotk;
            Cdotknk(k) = [];
            numo2 = numo2 + Cdotk(k) * sum(Cdotknk);
        end
        numo1 = sqrt(numo1);
        numo2 = sqrt(numo2);
        numo = (numo1*numo2);
        if numo==0
            numo = 10^-3;
        end

        MCC = deno/numo;
        measureValue = MCC;
         
     case 'RA'%regular accuracy
         measureValue = mean(Y==predictY);
     case 'KAPPA'
        measureValue = kappa(confusionMatrix);
         
 end