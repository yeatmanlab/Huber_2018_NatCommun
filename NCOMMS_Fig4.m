% This script reproduces Figure 4 from Huber et al., 2018

load('~/git/NCcode/data/AFQ_NCOMMS2018_rev2.mat')

% reading measure to correlate with white matter:
readtest = afq.metadata.readPC1;

% select nodes along the tract to average (middle 60%, i.e., nodes 21:80
% used in Huber et al. 2018)
nodesin = 21:80;

cmap = {[0,.4,0],[0,0,.6],[.5,0,.4]};

property = 'dki_MD';

tractid = [find(strcmp(afq.fgnames, 'Left Arcuate')), find(strcmp(afq.fgnames, 'Left ILF')),...
    find(strcmp(afq.fgnames, 'Callosum Forceps Major'))];

ct2 = 1;

for sess = 2:4
    
    readInt = readtest(intersect(find(afq.metadata.session == sess), find(afq.metadata.group == 1)));
    
    ct = 1;
    for tract = tractid        
        
        % Pull white matter values for a given tract from the AFQ structure:
        valsWM = AFQ_get(afq, afq.fgnames{tract}, property);
        % Convert to diffusivity measures to micrometers^2 per second
        if strcmp(property, 'dki_MD') || strcmp(property, 'dki_RD') || strcmp(property, 'dki_AD')
            valsWM = valsWM.*1000;
        end
        
        wmInt = valsWM(intersect(find(afq.metadata.session == sess), find(afq.metadata.group == 1)), nodesin);
        
        % Correlation values for plot
        [rint, pint] = corr(readInt, nanmean(wmInt,2),'rows','complete');
        
        subplot(3,numel(tractid),ct2)
        
        % plot intervention subjects with least squares fit line
        plot(nanmean(wmInt,2), readInt, 'o', 'MarkerSize', 10, 'Color', cmap{ct}, 'MarkerFaceColor', cmap{ct}), lsline, hold on
        
        box off
        axis('tight')
        
        title(strcat('r = ',num2str(r2p(rint, 2)),', p = ',num2str(r2p(pint, 2))))
        
        ylim([-40, 60])
        
        if ct == 1
            ylabel('Reading Score')
        end
        
        xlabel(afq.fgnames(tract), 'Interpreter', 'none')
        
        ct = ct + 1;
        ct2 = ct2 + 1;
        
    end
    
end
