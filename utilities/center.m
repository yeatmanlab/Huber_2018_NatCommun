function outvect = center(invect)
% mean center a vector
outvect = invect - nanmean(invect);