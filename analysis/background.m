% $Id$

slide_dirs = { '2004071501_thesis_slide_p23',...
        '2004080902_thesis_slide_p37',...
        '2004071502_thesis_slide_p47',...
        '2004080903_thesis_slide_p57',...
        '2004071503_thesis_slide_n19',...
        '2004080904_thesis_slide_n29',...
        '2004071504_thesis_slide_n71',...
        '2004080905_thesis_slide_n39',...
        '2004080901_thesis_slide_p17',...
        '2004080906_thesis_slide_n49' };

empty=readMeta('empty.xml','sngl_inspiral');

figure;
hold on;
sire_files = { 'l1-inca_l1h1.xml','h1-inca_l1h1.xml','l1-inca_l1h2.xml','h2-inca_l1h2.xml',...
        'l1-inca_l1h1h2.xml','h1-inca_l1h1h2.xml'};

clear coherent_snr;
for i = 1:2:length(sire_files)
    for j = 1:length(slide_dirs)
        try
            l_bkg(j) = readMeta( sprintf( 'background/%s/%s', char(slide_dirs(j)), char(sire_files(i)) ) ,...
                'sngl_inspiral' );
            h_bkg(j) = readMeta( sprintf( 'background/%s/%s', char(slide_dirs(j)), char(sire_files(i+1)) ) ,...
                'sngl_inspiral' );
            snrtmp = 1.0 ./ ( ( l_bkg(j).chisq ./ (15 + l_bkg(j).snr.^2 .* 0.2) ) + ...
                ( h_bkg(j).chisq ./ (15 + h_bkg(j).snr.^2 .* 0.2) ) );
            try
                coherent_snr = vertcat( coherent_snr, snrtmp );
            catch
                coherent_snr = snrtmp;
            end            
            plot(l_bkg(j).snr,h_bkg(j).snr,'r+');
        catch
            l_bkg(j) = empty;
            h_bkg(j) = empty;
        end
    end
end
xlabel('\rho_{L1}');
ylabel('\rho_{H1}');

%sire_files = { 'l1-inca_l1h1h2.xml', 'h2-inca_l1h1h2.xml'};
%for i = 1:2:length(sire_files)
%    for j = 1:length(slide_dirs)
%        try
%            l_bkg(j) = readMeta( sprintf( '%s/%s', char(slide_dirs(j)), char(sire_files(i)) ) ,...
%                'sngl_inspiral' );
%            h_bkg(j) = readMeta( sprintf( '%s/%s', char(slide_dirs(j)), char(sire_files(i+1)) ) ,...
%                'sngl_inspiral' );
%            plot(l_bkg(j).snr,h_bkg(j).snr,'bx');
%        catch
%            l_bkg(j) = empty;
%            h_bkg(j) = empty;
%        end
%    end
%end

title('Background');
hold off;

figure;
hist(coherent_snr,10);
xlabel('( (\chi^2_{L1} / 15 + 0.2 * \rho^2_{L1}) + (\chi^2_{H1} / 15 + 0.2 * \rho^2_{H1}) )^{-1}');
ylabel('Number');

clear coherent_snr;
figure;
hold on;

sire_files = { 'l1-inca_l1h1_inj_clust.xml','h1-inca_l1h1_inj_clust.xml','l1-inca_l1h2_inj_clust.xml','h2-inca_l1h2_inj_clust.xml',...
        'l1-inca_l1h1h2_inj_clust.xml','h1-inca_l1h1h2_inj_clust.xml'};
inj_dirs = {'2004062102_thesis_run_inj_4575','2004062104_thesis_run_inj_2501',...
        '2004062103_thesis_run_inj_2375','2004062105_thesis_run_inj_1945'};

for i = 1:2:length(sire_files)
    for j = 1:length(inj_dirs)-1
            l_fgd(j) = readMeta( sprintf( 'injections/%s/%s', char(inj_dirs(j)), char(sire_files(i)) ) ,...
                'sngl_inspiral' );
            h_fgd(j) = readMeta( sprintf( 'injections/%s/%s', char(inj_dirs(j)), char(sire_files(i+1)) ) ,...
                'sngl_inspiral' );
            snrtmp = 1.0 ./ ( ( l_fgd(j).chisq ./ (15 + l_fgd(j).snr.^2 .* 0.2) ) + ...
                ( h_fgd(j).chisq ./ (15 + h_fgd(j).snr.^2 .* 0.2) ) );
            try
                coherent_snr = vertcat( coherent_snr, snrtmp );
            catch
                coherent_snr = snrtmp;
            end            
            plot(l_fgd(j).snr,h_fgd(j).snr,'r+');
    end
end
xlabel('\rho_{L1}');
ylabel('\rho_{H1}');

title('Injections');
hold off;

figure;
hist(coherent_snr,100);
xlabel('( (\chi^2_{L1} / 15 + 0.2 * \rho^2_{L1}) + (\chi^2_{H1} / 15 + 0.2 * \rho^2_{H1}) )^{-1}');
ylabel('Number');

