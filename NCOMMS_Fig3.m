% This script reproduces Figure 3 from Huber et al., 2018

load('~/git/NCcode/data/AFQ_NCOMMS2018_rev2.mat')

% indices for group comparisons - intervention and control subjects
subind = find(afq.metadata.group == 1);
contind = find(afq.metadata.group == 0);

tractsIn = [find(strcmp(afq.fgnames, 'Left Arcuate')), find(strcmp(afq.fgnames, 'Left ILF')),...
    find(strcmp(afq.fgnames, 'Callosum Forceps Major'))];

readlist = {'wj_brs', 'twre_index'};

% Set a threshold for typically reading controls
% Huber et al. use use >= 85 on both the BRS and TOWRE at Session 1
cutoff = 85;
contind = intersect(contind, find(afq.metadata.session == 1));
contind = intersect(contind, find(afq.metadata.wj_brs >= cutoff));
contind = intersect(contind, find(afq.metadata.twre_index >= cutoff));

cmap = {[0,.4,0],[.3,.7,.3],[.5,.8,.3],[.8,1,.4];...
    [0,0,1],[0,.5,1],[0,.7,1],[0,1,1]; [1,0,0],[1,.5,0],[1,.7,0],[1,1,0]};

readnames = {'WJ Basic Reading', 'TOWRE Index'};

ctt = 1;

param = 'dki_MD';

for rr = 1:numel(readlist)
    
    ct = 1;
    
    readdata = eval(strcat('afq.metadata.', readlist{rr}));
    
    for ii = tractsIn
        
        figure(3)
        
        % Pull white matter values for a given tract from the AFQ structure:
        vals = AFQ_get(afq, afq.fgnames{ii}, param);
        
        % Convert to diffusivity measures to micrometers^2 per second
        if strcmp(param, 'dki_MD') || strcmp(param, 'dki_AD') || strcmp(param, 'dki_RD')
            vals = nanmean(vals(:,21:80),2)*1000;
        else
            vals = nanmean(vals(:,21:80),2);
        end
        
        subplot(numel(readlist), numel(tractsIn), ctt)
        
        set(gca, 'FontSize', 15)

        % plot control Session 1 data
        plotLMB2D(vals(contind),readdata(contind),[0.3,0.3,0.3]), hold on
        % plot intervention data for each session
        plotLMB2D(vals(intersect(subind, find(afq.metadata.session == 1))),...
            readdata(intersect(subind, find(afq.metadata.session == 1))),cmap{ct,1}), hold on
        plotLMB2D(vals(intersect(subind, find(afq.metadata.session == 2))),...
            readdata(intersect(subind, find(afq.metadata.session == 2))),cmap{ct,2})
        plotLMB2D(vals(intersect(subind, find(afq.metadata.session == 3))),...
            readdata(intersect(subind, find(afq.metadata.session == 3))),cmap{ct,3})
        plotLMB2D(vals(intersect(subind, find(afq.metadata.session == 4))),...
            readdata(intersect(subind, find(afq.metadata.session == 4))),cmap{ct,4})
        
        title(afq.fgnames{ii}, 'Interpreter', 'none')
        
        xlabel(param, 'Interpreter', 'none')
        ylabel(readnames{rr})
        
        axis('tight')
       
        % tract ID
        ct = ct+1;
        
        % subplot ID
        ctt = ctt + 1;
        
    end
    
end
