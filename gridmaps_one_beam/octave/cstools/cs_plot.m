function cs_plot(ranges_true, ranges_reconstructed, cs_percent, theta_pointer)
    figure
    h(1) = plot(ranges_true,'-rx','MarkerSize',12);
    hold on
    for i = 1:numel(theta_pointer)
        h(i+1) = line([theta_pointer(i) theta_pointer(i)], [0 ranges_true(theta_pointer(i))],'Color','red','LineStyle',':');
        %xline(theta_pointer(i),':r')
        hold on
    end
    h(numel(theta_pointer)+2) = plot(ranges_reconstructed,'-bo');
    %legend('original','samples','reconstructed')
    legend([h(1) h(2) h(end)],{'original','samples','reconstructed'})
    xlabel('bearing')
    ylabel('range')
    title(sprintf("compression level %.2f", cs_percent));
    hold off
