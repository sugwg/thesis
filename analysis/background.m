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


for i = 1:length(slide_dirs)
    for l = 1:length(coinc)
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
                
                try 
                    lag(i).l = vertcat( lag(i).l, tmp.snr )
                catch
                    lag(i).l = tmp.snr
                end
                   
            catch
                fprintf(2,'empty file\n')
                
                try 
                    lag(i).l = vertcat( lag(i).l, 0)
                catch
                    lag(i).l = 0
                end

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
                
                try 
                    lag(i).h = vertcat( lag(i).h, tmp.snr)
                catch
                    lag(i).h = tmp.snr
                end
                
            catch
                fprintf(2,'empty file\n')
                
                try 
                    lag(i).h = vertcat( lag(i).h, 0)
                catch
                    lag(i).h = 0
                end

            end
                        
        end
        
    end
    lag(i).coherent = lag(i).l.^2 + lag(i).h.^2 / 4;
end

trig.l1h2.l = readMeta('box/l1-inca_l1h2_box_clust.xml','sngl_inspiral');
trig.l1h2.h = readMeta('box/h2-inca_l1h2_box_clust.xml','sngl_inspiral');
trig.l1h1h1.l = readMeta('box/l1-inca_l1h1h2_box_clust.xml','sngl_inspiral');
trig.l1h1h1.h = readMeta('box/h1-inca_l1h1h2_box_clust.xml','sngl_inspiral');

f = figure;
%plot(bkg.l1h1.l.snr,bkg.l1h1.h.snr,'+', bkg.l1h2.l.snr,bkg.l1h2.h.snr,'+',  bkg.l1h1h1.l.snr,bkg.l1h1h1.h.snr,'+',...
%    trig.l1h2.l.snr, trig.l1h2.h.snr,'o', trig.l1h1h1.l.snr, trig.l1h1h1.h.snr,'o');
%legend('L1H1 background','L1H2 background','L1H1H2 background (H1 only)','L1H2 Triggers','L1H1H2 Triggers (H1 only)');

plot(bkg.l1h1.l.snr,bkg.l1h1.h.snr,'+', bkg.l1h2.l.snr,bkg.l1h2.h.snr,'+',  bkg.l1h1h1.l.snr,bkg.l1h1h1.h.snr,'+');
legend('L1H1 background','L1H2 background','L1H1H2 background (H1 only)');

xlabel('\rho_{L1}');
ylabel('\rho_H');
title('Full Data Set MACHO Triggers');
grid on;
axis([7 14 7 14]);
% saveas(f,'figures/bkg_fgd','pdf');
% saveas(f,'figures/bkg_fgd','png');
axis([7 8 7 8]);
% saveas(f,'figures/bkg_fgd_zoom','pdf');
% saveas(f,'figures/bkg_fgd_zoom','png');

for l = 1:length(coinc)
    %    bkg.(char(coinc(l))).co_snr = 1.0 ./ ( ( bkg.(char(coinc(l))).l.chisq ./ (15 + bkg.(char(coinc(l))).l.snr.^2 .* 0.2) ) + ...
    %        ( bkg.(char(coinc(l))).h.chisq ./ (15 + bkg.(char(coinc(l))).h.snr.^2 .* 0.2) ) );   
    
    bkg.(char(coinc(l))).co_snr = bkg.(char(coinc(l))).l.snr.^2 + ( bkg.(char(coinc(l))).h.snr.^2 ./ 4) ;   
    try
        bkg_co_snr = vertcat( bkg_co_snr, bkg.(char(coinc(l))).co_snr );
    catch
        bkg_co_snr = bkg.(char(coinc(l))).co_snr;
    end
end

f = figure;
hist(bkg_co_snr);
title('Background MACHO Triggers');
grid on;
xlabel('\rho^2_{L1} + \rho^2_{H} / 4');
ylabel('N');
% saveas(f,'figures/bkg_hist','pdf');
% saveas(f,'figures/bkg_hist','png');

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
            
            tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sim_inspiral' );
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    found.(char(ifonames(ifo))).l.(char(names(k))) = vertcat(found.(char(ifonames(ifo))).l.(char(names(k))),tmp.(char(names(k))));
                end
            catch
                found.(char(ifonames(ifo))).l = tmp;
            end
            
            tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j+1)) ), 'sim_inspiral' );
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    found.(char(ifonames(ifo))).h.(char(names(k))) = vertcat(found.(char(ifonames(ifo))).h.(char(names(k))),tmp.(char(names(k))));
                end
            catch
                found.(char(ifonames(ifo))).h = tmp;
            end
            
            tmp = readMeta( sprintf( 'injections/%s/%s_missed.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sim_inspiral' );
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    missed.(char(names(k))) = vertcat(missed.(char(names(k))) ,tmp.(char(names(k))));
                end
            catch
                missed = tmp;
            end
            
        end
    end
end

for l = 1:length(coinc)
    %    cand.(char(coinc(l))).co_snr = 1.0 ./ ( ( cand.(char(coinc(l))).l.chisq ./ (15 + cand.(char(coinc(l))).l.snr.^2 .* 0.2) ) + ...
    %        ( cand.(char(coinc(l))).h.chisq ./ (15 + cand.(char(coinc(l))).h.snr.^2 .* 0.2) ) );   
    
    cand.(char(coinc(l))).co_snr = ...
        cand.(char(coinc(l))).l.snr(   found.(char(coinc(l))).l.mass1 > 0.2 &  found.(char(coinc(l))).l.mass2 > 0.2   ).^2 +...
        ( cand.(char(coinc(l))).h.snr(  found.(char(coinc(l))).h.mass1 > 0.2 &  found.(char(coinc(l))).h.mass2 > 0.2   ).^2 ./ 4) ;   
    
%    cand.(char(coinc(l))).co_snr = ...
%        cand.(char(coinc(l))).l.snr.^2 +...
%        ( cand.(char(coinc(l))).h.snr.^2 ./ 4) ;   

    
    try
        cand_co_snr = vertcat( cand_co_snr, cand.(char(coinc(l))).co_snr );
    catch
        cand_co_snr = bkg.(char(coinc(l))).co_snr;
    end
    
end

f = figure;
plot(cand.l1h1.l.snr,cand.l1h1.h.snr,'+', cand.l1h2.l.snr,cand.l1h2.h.snr,'+',  cand.l1h1h1.l.snr,cand.l1h1h1.h.snr,'+');
legend('L1H1','L1H2','L1H1H2 (H1 only)');
xlabel('\rho_{L1}');
ylabel('\rho_H');
title('Playground MACHO Injections');
grid on;
% saveas(f,'figures/inj_snr','png');
% saveas(f,'figures/inj_snr','pdf');

f = figure;
hist(cand_co_snr(cand_co_snr>=1000),100);
title('Playground MACHO Injections');
grid on;
xlabel('\rho^2_{L1} + \rho^2_{H} / 4 >= 1000');
ylabel('N');
% saveas(f,'figures/inj_hist_hi','png');
% saveas(f,'figures/inj_hist_hi','pdf');

f = figure;
hist(cand_co_snr(cand_co_snr<1000),100);
title('Playground MACHO Injections');
grid on;
xlabel('\rho^2_{L1} + \rho^2_{H} / 4 < 1000');
ylabel('N');
% saveas(f,'figures/inj_hist_lo','png');
% saveas(f,'figures/inj_hist_lo','pdf');

f = figure;
plot(cand.l1h1.l.snr(   found.l1h1.l.mass1 > 0.2 &  found.l1h1.l.mass2 > 0.2   ),...
    cand.l1h1.h.snr(   found.l1h1.h.mass1 > 0.2 &  found.l1h1.h.mass2 > 0.2   ),'b+',...
    bkg.l1h1.l.snr,bkg.l1h1.h.snr,'rx',...
    cand.l1h2.l.snr(   found.l1h2.l.mass1 > 0.2 &  found.l1h2.l.mass2 > 0.2   ),...
    cand.l1h2.h.snr(   found.l1h2.h.mass1 > 0.2 &  found.l1h2.h.mass2 > 0.2   ),'b+',...
    cand.l1h1h1.l.snr(   found.l1h1h1.l.mass1 > 0.2 &  found.l1h1h1.l.mass2 > 0.2   ),...
    cand.l1h1h1.h.snr(   found.l1h1h1.h.mass1 > 0.2 &  found.l1h1h1.h.mass2 > 0.2   ),'b+',...
    bkg.l1h2.l.snr,bkg.l1h2.h.snr,'rx',...
    bkg.l1h1h1.l.snr,bkg.l1h1h1.h.snr,'rx');
legend('Injections','Background');
xlabel('\rho_{L1}');
ylabel('\rho_H');
axis([7 30 7 30]);
title('MACHO Playground Injections and Background');
grid on;
% saveas(f,'figures/inj_bkg_snr','png');
% saveas(f,'figures/inj_bkg_snr','pdf');


for i = 1:length(lag)
pb(i)=length(lag(i).coherent(lag(i).coherent>67.4225));
end

f = figure;
hist(pb)

clear i j k l coinc sire_files names slide_dirs tmp;
