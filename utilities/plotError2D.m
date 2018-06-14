function plotError2D(xvals, yvals, xcolor, ycolor, xywidth)

if ~exist('xcolor', 'var')
    xcolor = [0,0,0];
end
if ~exist('ycolor', 'var')
    ycolor = [0,0,0];
end
if ~exist('xywidth', 'var')
    xywidth = 2;
end

line(xvals, ones(size(xvals))*nanmean(yvals), 'Color', xcolor, 'LineWidth', xywidth), hold on
line(ones(size(yvals))*nanmean(xvals), yvals, 'Color', ycolor, 'LineWidth', xywidth)
