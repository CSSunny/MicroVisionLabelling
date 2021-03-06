% load ellipses_with_area.mat

[sorted_time, index] = sort(time);
sorted_ellipse_alpha = ellipse_alpha(index);
sorted_ellipse_beta = ellipse_beta(index);

t = datetime(sorted_time./1000,'ConvertFrom','posixTime','TimeZone','America/New_York','Format','dd-MMM-yyyy HH:mm:ss.SSS');
t = t - t(1);
nbins = 25;
colors={'g','b','r','y'};
working_on = sorted_ellipse_alpha;
selected_axis = 2; % long

selected_time = { minutes(150)};
selected_time = flip(selected_time);
for i = 1 : numel(selected_time)
    index =  find(t >selected_time{i}, 1);
    cur_obj = working_on{index};
    cur_area = cell2mat(cur_obj(:,2))*1.3*1.3;
    cur_ellipse = cell2mat(cur_obj(:,1));
    cur_ax = cur_ellipse(:, selected_axis);
    
    cur_dist = cur_ax*1.3;
    cur_dist(cur_dist <1) = [];

    [N, edges, bins] = histcounts(cur_dist, logspace(log10(min(cur_dist)), log10(max(cur_dist)), nbins));
    
    % bins are the indices of which the cur_dist element belongs to
    N_area = [];
    for j = 1 : numel(N)
        N_area(j) = sum(cur_area(bins==j));
    end  
    center = ((edges(1:end-1) - edges(2:end))./(log(edges(1:end-1)) - log(edges(2:end))));
    
    x = bar2x(center, N_area);
    dist = fitdist(x,'Lognormal');

    plotrange = linspace(8, 2200, 500);
    h = plot( plotrange, dist.pdf(plotrange));
    set(gca, 'XScale', 'log');
    hold on

    %ylabel('Area (\mum ^2)')
    %ylabel('Area %')
    %xlabel('Ellipse Long Axis Length (\mum)')
end