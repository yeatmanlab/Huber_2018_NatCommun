function plotLMB2D(xvals, yvals, xycolor)

if ~exist('xycolor', 'var')
    xycolor = [0,0,0];
end

plot(nanmean(xvals), nanmean(yvals),'o','Color', xycolor,'MarkerFaceColor', xycolor); hold on

% needs to interp to a factor of 3 to center on the mean - could add a resample fac variable = 3*n
plotError2D(linspace(nanmean(xvals)-sem(xvals),nanmean(xvals)+sem(xvals),9),...
    linspace(nanmean(yvals)-sem(yvals),nanmean(yvals)+sem(yvals),9), xycolor, xycolor, 2)

% axis('tight')
box off