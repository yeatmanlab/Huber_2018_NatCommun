% This script reproduces Figure 1 from Huber et al., 2018

load('~/git/NCcode/data/AFQ_NCOMMS2018_rev2.mat')

% indices for group comparisons - intervention and control subjects
subind = find(afq.metadata.group == 1);
contind = find(afq.metadata.group == 0);

% reading measure to correlate with white matter:
readtest = afq.metadata.readPC1;

% select nodes along the tract to average (middle 60%, i.e., nodes 21:80
% used in Huber et al. 2018)
nodesin = 21:80;

cmap = {[0,.4,0],[0,0,.6],[.5,0,.4]};

tractid = [find(strcmp(afq.fgnames, 'Left Arcuate')), find(strcmp(afq.fgnames, 'Left ILF')),...
    find(strcmp(afq.fgnames, 'Callosum Forceps Major'))];

property = 'dki_MD';

figure(1)

ct = 1;
for tract = tractid
    % We want to calculate the correlation with reading for the
    % intervention group, and also for the whole sample (intervention +
    % control) at time point 1:
    readInt = readtest(intersect(find(afq.metadata.session == 1), subind));
    readCont = readtest(intersect(find(afq.metadata.session == 1),contind));
    
    % Pull white matter values for a given tract from the AFQ structure:
    valsWM = AFQ_get(afq, afq.fgnames{tract}, property);
    % Convert to diffusivity measures to micrometers^2 per second
    if strcmp(property, 'dki_MD') || strcmp(property, 'dki_RD') || strcmp(property, 'dki_AD')
        valsWM = valsWM.*1000;
    end
    
    wmInt = valsWM(intersect(find(afq.metadata.session == 1), subind), nodesin);
    wmCont = valsWM(intersect(find(afq.metadata.session == 1), contind), nodesin);
    
    % Correlation values for plot
    [r, p] = corr([readInt;readCont], [nanmean(wmInt,2);nanmean(wmCont,2)],'rows','complete');
    [rint, pint] = corr(readInt, nanmean(wmInt,2),'rows','complete');
    
    subplot(1,numel(tractid),ct)
    % least squares fit line for the full sample
    plot([nanmean(wmInt,2);nanmean(wmCont,2)], [readInt;readCont], '.','Color', [.8,.8,.8], 'MarkerEdgeColor', [.8,.8,.8]), lsline
    % plot intervention and control subjects with least squares fit line
    % for intervention group
    plot(nanmean(wmInt,2), readInt, 'o', 'MarkerSize', 10, 'Color', cmap{ct}, 'MarkerFaceColor', cmap{ct}), lsline, hold on
    plot(nanmean(wmCont,2), readCont, 'o', 'MarkerSize', 10, 'MarkerFaceColor', [1,1,1],...
        'MarkerEdgeColor',cmap{ct}), hold on
    box off
    
    title(strcat('r = ',num2str(r2p(rint, 2)),', p = ',num2str(r2p(pint, 2)),...
        ' (', ' r = ',num2str(r2p(r, 2)),', p = ',num2str(r2p(p, 2)), ')'))
    
    axis('tight')
    ylim([-40, 60])
    
    if ct == 1
        ylabel('Reading Score')
    end
    
    xlabel([afq.fgnames(tract), ' ', property], 'Interpreter', 'none')
    
    ct = ct + 1;
end
