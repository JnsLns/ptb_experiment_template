hCa = gca;
hCf = gcf;
caPos = hCa.Position;
nSteps = 151;

nPts = 12; % for t-test
useHalf = 0; % zero to use all (else 1 or 2) this is to extract two effect peaks like in mixture of spatial term and reference effect
     
% get effect size data for current axes 
hEsAx = findobj(hCf.Children,'tag','esAx','position',caPos);
esData = hEsAx.Children.CData;
% same for p-value
hSigAx = findobj(hCf.Children,'tag','sigAx','position',caPos);
sigData = get(findobj(hSigAx.Children,'tag','sigImg'),'CData');

addBaseSteps = 0; % for correct percetnage computation 
switch useHalf
    case 1
        warning('using only first half of all time steps');
        sigData(ceil(nSteps/2):end) = [];
        esData(ceil(nSteps/2):end) = [];        
    case 2                  
        warning('using only second half of all time steps');
        sigData(1:ceil(nSteps/2)-1) = [];
        esData(1:ceil(nSteps/2)-1) = [];
        addBaseSteps = ceil(nSteps/2)-1;
end

% get min p / max es for data acquired above
[minP,minPStep] = min(sigData);
[maxEs, maxEsStep] = max(esData);

% t-test at that step
tVal = sqrt(nPts)*maxEs; % t-value computed from cohen's d, just to check consistency
pFromT = tcdf(tVal,nPts-1,'upper')*2; % p-value computed from this
if minP-pFromT ~= 0; warning(['wrong t? Diff is ' num2str(minP-pFromT)]); end

%resStr = ['with the minimum \p{} value occurring at \SI{' num2str(round(minPStep/nSteps*100,2)) '}{percent} movement time ($t(' num2str(nPts-1) ')=' num2str(round(tVal,2)) '$, $\p{}=' num2str(minP) '$, $d_z=' num2str(round(maxEs,2)) '$)'];
nDecs = '11';
resStr = ['with the minimum \p{} value occurring at \SI{' num2str(round((minPStep+addBaseSteps)/nSteps*100,2)) '}{percent} movement time ($t(' num2str(nPts-1) ')=' num2str(round(tVal,2)) '$, $\p{}=' sprintf(['%0.' nDecs 'f'],minP) '$, $d_z=' num2str(round(maxEs,2)) '$).'];

clipboard('copy',resStr);






% % find sig dots for current axes and determine their number
% hSigAx = findobj(hCf.Children,'tag','sigAx','position',caPos);
% hSigDots = findobj(hSigAx,'tag','sigDot');
% numel(hSigDots)
% 
% % move sig dots axes to top layer for single-axes figure
% hCf.Children = hCf.Children([4 1 2 3 5 6 7]);
% 
% % move sig dots axes to top layer for two-axes figure
% hCf.Children = hCf.Children([4 9 1 2 3 5 6 7 8 10 11])

%%






