% $Id$

clear;
clc;
fprintf(2,'Warning: this script does not work properly if there are triple coincident triggers\n');

slide_dirs = { '2004071501_thesis_slide_p23',...
        '2004080902_thesis_slide_p37',...
        '2004071502_thesis_slide_p47',...
        '2004080903_thesis_slide_p57',...
        '2004071503_thesis_slide_n19',...
        '2004080904_thesis_slide_n29',...
        '2004071504_thesis_slide_n71',...
        '2004080905_thesis_slide_n39',...
        '2004080901_thesis_slide_p17',...
        '2004080906_thesis_slide_n49',...
        '2004081201_thesis_slide_p67',...
        '2004081202_thesis_slide_p77',...
        '2004081203_thesis_slide_p87',...
        '2004081204_thesis_slide_p97',...
        '2004081205_thesis_slide_n59',...
        '2004081206_thesis_slide_n69',...
        '2004081207_thesis_slide_n79',...
        '2004081208_thesis_slide_n89',...
        '2004081209_thesis_slide_n99',...
        '2004081210_thesis_slide_p13' };

sire_files.l1h1 = {'l1-inca_l1h1_clust.xml','h1-inca_l1h1_clust.xml'};
sire_files.l1h2 = {'l1-inca_l1h2_clust.xml','h2-inca_l1h2_clust.xml'};
sire_files.l1h1h1 = {'l1-inca_l1h1h2_clust.xml','h1-inca_l1h1h2_clust.xml'};

%sire_files.l1h1 = {'l1-inca_l1h1.xml','h1-inca_l1h1.xml'};
%sire_files.l1h2 = {'l1-inca_l1h2.xml','h2-inca_l1h2.xml'};
%sire_files.l1h1h1 = {'l1-inca_l1h1h2.xml','h1-inca_l1h1h2.xml'};

coinc = fieldnames(sire_files);

for l = 1:length(coinc)
    for i = 1:length(slide_dirs)
        for j = 1:2:length(sire_files)
            
            try
                fprintf(2,'%s/%s: ', char(slide_dirs(i)), char(sire_files.(char(coinc(l)))(j)))
                tmp = readMeta( sprintf( 'background/%s/%s', char(slide_dirs(i)), char(sire_files.(char(coinc(l)))(j) )), 'sngl_inspiral' );
                
                try
                    names = fieldnames(tmp);
                    for k = 1:length(names)
                        bkg.(char(coinc(l))).l.(char(names(k))) = vertcat(bkg.(char(coinc(l))).l.(char(names(k))),  tmp.(char(names(k))));
                    end
                catch
                    bkg.(char(coinc(l))).l = tmp;
                end
                
            catch
                fprintf(2,'empty file\n')
            end
            
            try
                fprintf(2,'%s/%s: ', char(slide_dirs(i)), char(sire_files.(char(coinc(l)))(j+1)))
                tmp = readMeta( sprintf( 'background/%s/%s', char(slide_dirs(i)), char(sire_files.(char(coinc(l)))(j+1) )), 'sngl_inspiral' );
                
                try
                    names = fieldnames(tmp);
                    for k = 1:length(names)
                        bkg.(char(coinc(l))).h.(char(names(k))) = vertcat(bkg.(char(coinc(l))).h.(char(names(k))),  tmp.(char(names(k))));
                    end
                catch
                    bkg.(char(coinc(l))).h = tmp;
                end
                
            catch
                fprintf(2,'empty file\n')
            end
                        
        end
    end
end

figure;
plot(bkg.l1h1.l.snr,bkg.l1h1.h.snr,'+', bkg.l1h2.l.snr,bkg.l1h2.h.snr,'+',  bkg.l1h1h1.l.snr,bkg.l1h1h1.h.snr,'+');
legend('L1H1','L1H2','L1H1H2 (H1 only)');
xlabel('\rho_{L1}');
ylabel('\rho_H');
title('Background MACHO Triggers');
grid on;

for l = 1:length(coinc)
    bkg.(char(coinc(l))).co_snr = 1.0 ./ ( ( bkg.(char(coinc(l))).l.chisq ./ (15 + bkg.(char(coinc(l))).l.snr.^2 .* 0.2) ) + ...
        ( bkg.(char(coinc(l))).h.chisq ./ (15 + bkg.(char(coinc(l))).h.snr.^2 .* 0.2) ) );   
    try
        bkg_co_snr = vertcat( bkg_co_snr, bkg.(char(coinc(l))).co_snr );
    catch
        bkg_co_snr = bkg.(char(coinc(l))).co_snr;
    end
end

figure;
hist(bkg_co_snr);
title('Background MACHO Triggers');
grid on;
xlabel('( (\chi^2_{L1} / 15 + 0.2 * \rho^2_{L1}) + (\chi^2_{H} / 15 + 0.2 * \rho^2_{H}) )^{-1}');
ylabel('N');

clear sire_files;

inj_dirs = { '2004062102_thesis_run_inj_4575','2004062103_thesis_run_inj_2375',...
        '2004062104_thesis_run_inj_2501','2004062105_thesis_run_inj_1945' };

sire_files.l1h1 = { 'l1-inca_l1h1', 'h1-inca_l1h1' };
sire_files.l1h2 = { 'l1-inca_l1h2', 'h2-inca_l1h2' };
sire_files.l1h1h1 = { 'l1-inca_l1h1h2', 'h1-inca_l1h1h2' };

ifonames = fieldnames(sire_files);

for ifo = 1:length(ifonames)
    for i = 1:length(inj_dirs)
        for j = 1:2:length(sire_files.(char(ifonames(ifo))))
            
            tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sngl_inspiral' );
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    cand.(char(ifonames(ifo))).l.(char(names(k))) = vertcat(cand.(char(ifonames(ifo))).l.(char(names(k))),tmp.(char(names(k))));
                end
            catch
                cand.(char(ifonames(ifo))).l = tmp;
            end
            
            tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j+1)) ), 'sngl_inspiral' );
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    cand.(char(ifonames(ifo))).h.(char(names(k))) = vertcat(cand.(char(ifonames(ifo))).h.(char(names(k))),tmp.(char(names(k))));
                end
            catch
                cand.(char(ifonames(ifo))).h = tmp;
            end
            
        end
    end
end


for l = 1:length(coinc)
    cand.(char(coinc(l))).co_snr = 1.0 ./ ( ( cand.(char(coinc(l))).l.chisq ./ (15 + cand.(char(coinc(l))).l.snr.^2 .* 0.2) ) + ...
        ( cand.(char(coinc(l))).h.chisq ./ (15 + cand.(char(coinc(l))).h.snr.^2 .* 0.2) ) );   
    try
        cand_co_snr = vertcat( cand_co_snr, cand.(char(coinc(l))).co_snr );
    catch
        cand_co_snr = bkg.(char(coinc(l))).co_snr;
    end
end

figure;
plot(cand.l1h1.l.snr,cand.l1h1.h.snr,'+', cand.l1h2.l.snr,cand.l1h2.h.snr,'+',  cand.l1h1h1.l.snr,cand.l1h1h1.h.snr,'+');
legend('L1H1','L1H2','L1H1H2 (H1 only)');
xlabel('\rho_{L1}');
ylabel('\rho_H');
title('Playground MACHO Injections');
grid on;

figure;
hist(cand_co_snr,100);
title('Playground MACHO Injections');
grid on;
xlabel('( (\chi^2_{L1} / 15 + 0.2 * \rho^2_{L1}) + (\chi^2_{H} / 15 + 0.2 * \rho^2_{H}) )^{-1}');
ylabel('N');

figure;
hold on;
plot(cand.l1h1.l.snr,cand.l1h1.h.snr,'b+', cand.l1h2.l.snr,cand.l1h2.h.snr,'b+',  cand.l1h1h1.l.snr,cand.l1h1h1.h.snr,'b+');
plot(bkg.l1h1.l.snr,bkg.l1h1.h.snr,'rx', bkg.l1h2.l.snr,bkg.l1h2.h.snr,'rx',  bkg.l1h1h1.l.snr,bkg.l1h1h1.h.snr,'rx');
xlabel('\rho_{L1}');
ylabel('\rho_H');
axis([7 30 7 30]);
grid on;

clear i j k l coinc sire_files names slide_dirs tmp;