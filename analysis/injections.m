% $Id$

clear;

inj_dirs = { '2004062102_thesis_run_inj_4575','2004062103_thesis_run_inj_2375',...
        '2004062104_thesis_run_inj_2501','2004062105_thesis_run_inj_1945' };

sire_files.l1 = { 'l1-inca_l1h1h2', 'l1-inca_l1h1', 'l1-inca_l1h2' };
sire_files.H1 = { 'h1-inca_l1h1h2', 'h1-inca_l1h1' };
sire_files.H2 = { 'h2-inca_l1h2' };

ifonames = fieldnames(sire_files);

for ifo = 1:length(ifonames)
    for i = 1:length(inj_dirs)
        for j = 1:length(sire_files.(char(ifonames(ifo))))
            
            tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sim_inspiral');
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    found.(char(ifonames(ifo))).(char(names(k))) = vertcat(found.(char(ifonames(ifo))).(char(names(k))),tmp.(char(names(k))));
                end
            catch
                found.(char(ifonames(ifo))) = tmp;
            end
            
            tmp = readMeta( sprintf( 'injections/%s/%s_missed.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sim_inspiral' );
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    missed.(char(ifonames(ifo))).(char(names(k))) = vertcat(missed.(char(ifonames(ifo))).(char(names(k))),tmp.(char(names(k))));
                end
            catch
                missed.(char(ifonames(ifo))) = tmp;
            end

            tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sngl_inspiral' );
            try
                names = fieldnames(tmp);
                for k = 1:length(names)
                    cand.(char(ifonames(ifo))).(char(names(k))) = vertcat(cand.(char(ifonames(ifo))).(char(names(k))),tmp.(char(names(k))));
                end
            catch
                cand.(char(ifonames(ifo))) = tmp;
            end
            
        end
    end
end

for ifo = 1:length(ifonames)
    found.(char(ifonames(ifo))).mlow=found.(char(ifonames(ifo))).mass2(found.(char(ifonames(ifo))).mass1 > 0.2 & found.(char(ifonames(ifo))).mass2 > 0.2);
    found.(char(ifonames(ifo))).mhigh=found.(char(ifonames(ifo))).mass1(found.(char(ifonames(ifo))).mass1 > 0.2 & found.(char(ifonames(ifo))).mass2 > 0.2);
    missed.(char(ifonames(ifo))).mlow=missed.(char(ifonames(ifo))).mass2(missed.(char(ifonames(ifo))).mass1 > 0.2 & missed.(char(ifonames(ifo))).mass2 > 0.2);
    missed.(char(ifonames(ifo))).mhigh=missed.(char(ifonames(ifo))).mass1(missed.(char(ifonames(ifo))).mass1 > 0.2 & missed.(char(ifonames(ifo))).mass2 > 0.2);
    missed.(char(ifonames(ifo))).mchirp = ( (missed.(char(ifonames(ifo))).mass1.*missed.(char(ifonames(ifo))).mass2).^(3/5) ) ./ ...
        ( (missed.(char(ifonames(ifo))).mass1 + missed.(char(ifonames(ifo))).mass2).^(1/5) );
    found.(char(ifonames(ifo))).mchirp = ( (found.(char(ifonames(ifo))).mass1.*found.(char(ifonames(ifo))).mass2).^(3/5) ) ./ ...
        ( (found.(char(ifonames(ifo))).mass1 + found.(char(ifonames(ifo))).mass2).^(1/5) );
    cand.(char(ifonames(ifo))).eff_distance_corrected = ( cand.(char(ifonames(ifo))).sigmasq ./ ( cand.(char(ifonames(ifo))).snr.^2 - 2 ) ).^(1/2);
end

s2start = 729273613;
found.l1.t = ( (found.l1.l_end_time+found.l1.l_end_time_ns/1000000000) - s2start );
cand.l1.t = ( (cand.l1.end_time+cand.l1.end_time_ns/1000000000) - s2start );

for ifo = 2:length(ifonames)
    found.(char(ifonames(ifo))).t = (found.(char(ifonames(ifo))).h_end_time+found.(char(ifonames(ifo))).h_end_time_ns/1000000000) - s2start;
    cand.(char(ifonames(ifo))).t = (cand.(char(ifonames(ifo))).end_time+cand.(char(ifonames(ifo))).end_time_ns/1000000000) - s2start;
end


f = figure;
scatter(missed.H1.mass1,missed.H1.mass2,50,missed.H1.eff_dist_h,'^','filled');
grid on;
c = colorbar;
set(get(c,'XLabel'),'String','D (Mpc)')
vline(0.2,'r');
hline(0.2,'r');
xlabel('Mass 1');
ylabel('Mass 2');
title('H1 Missed MACHO Playground Injections');
%saveas(f,'m1m2_missed','png');
saveas(f,'figures/m1m2_missed','pdf');

f = figure;
scatter(found.H1.mass1,found.H1.mass2,50,found.H1.eff_dist_h,'o','filled');
grid on;
c = colorbar;
set(get(c,'XLabel'),'String','D (Mpc)')
vline(0.2,'r');
hline(0.2,'r');
xlabel('Mass 1');
ylabel('Mass 2');
title('H1 Found MACHO Playground Injections');
%saveas(f,'m1m2_found','png');
saveas(f,'figures/m1m2_found','pdf');

f = figure;
plot(missed.H1.mlow(missed.H1.mlow>0.2),missed.H1.mhigh(missed.H1.mlow>0.2),'rx',...
    found.H1.mlow(found.H1.mlow>0.2),found.H1.mhigh(found.H1.mlow>0.2),'b+');
vline(0.2);
hline(0.2);
xlabel('Mass 1');
ylabel('Mass 2');
title('H1 Missed MACHO Playground Injections');
grid on;
saveas(f,'figures/m1m2_found_missed','png');
saveas(f,'figures/m1m2_found_missed','pdf');

mbin=(0.2:0.025:1.0);
n=histc([missed.H1.mhigh; found.H1.mhigh],mbin);
nmissed=histc(missed.H1.mhigh,mbin);
nfound=histc(found.H1.mhigh,mbin);

f = figure;
subplot(2,1,1);
bar(mbin,nmissed./n,'histc','r');
title('H1 MACHO Playground Injections');
xlabel('mass_1 (solar masses)');
ylabel('1 - \epsilon');
legend('Missed');
grid on;
axis([0.2 1 0 1.1]);
subplot(2,1,2);
bar(mbin,nfound./n,'histc','b');
xlabel('mass_1 (solar masses)');
ylabel('\epsilon');
legend('Found');
grid on;
axis([0.2 1 0 1.1]);

saveas(f,'figures/msun_eff','png');
saveas(f,'figures/msun_eff','pdf');

mbin=(0.1741:0.0348:0.8706);
n=histc([missed.H1.mchirp(missed.H1.mchirp>0.1741); found.H1.mchirp(found.H1.mchirp>0.1741)],mbin);
nmissed=histc(missed.H1.mchirp(missed.H1.mchirp>0.1741),mbin);
nfound=histc(found.H1.mchirp(found.H1.mchirp>0.1741),mbin);

f = figure;
subplot(2,1,1);
bar(mbin,nmissed./n,'histc','r');
title('H1 MACHO Playground Injections');
xlabel('Chirp Mass');
ylabel('1 - \epsilon');
legend('Missed');
grid on;
subplot(2,1,2);
bar(mbin,nfound./n,'histc','b');
xlabel('Chirp Mass');
ylabel('\epsilon');
legend('Found');
grid on;

saveas(f,'figures/mchirp_eff','png');
saveas(f,'figures/mchirp_eff','pdf');

f = figure;
plot(found.H1.mchirp,found.H1.eff_dist_h,'b+',missed.H1.mchirp,missed.H1.eff_dist_h,'rx');
legend('Found','Missed')
xlabel('Chirp Mass');
ylabel('LHO Effective Distance');
title('H1 MACHO Playground Injections');
grid on;

saveas(f,'figures/mchirp_found_missed','png');
saveas(f,'figures/mchirp_found_missed','pdf');

f = figure;
subplot(3,2,1);
plot(cand.l1.eff_distance,found.l1.eff_dist_l,'x')
grid on;
xlabel('L1 Recovered Effective Distance (Mpc)');
ylabel('L1 Injected Effective Distance (Mpc)');
subplot(3,2,2);
hist((cand.l1.eff_distance_corrected-found.l1.eff_dist_l)./found.l1.eff_dist_l,50);
grid on;
xlabel('L1 \Delta D / D (Mpc)');
ylabel('L1 Number of Injections');
subplot(3,2,3);
plot(cand.l1.mchirp,found.l1.mchirp,'x')
grid on;
xlabel('L1 Recovered M_{chirp}');
ylabel('L1 Injected M_{chirp}');
subplot(3,2,4);
hist( (cand.l1.mchirp-found.l1.mchirp) ./ found.l1.mchirp ,50);
grid on;
xlabel('L1 \Delta M_{chirp} / M_{chirp}');
ylabel('L1 Number of Injections');
subplot(3,2,5);
plot(cand.l1.t./3600,found.l1.t./3600,'x')
grid on;
xlabel('L1 Recovered End Time (hours since 729273613)');
ylabel('L1 Injected End Time (hours since 729273613)');
subplot(3,2,6);
hist((cand.l1.t-found.l1.t)*1000,50);
grid on;
xlabel('L1 \Delta t (ms)');
ylabel('L1 Number of Injections');

saveas(f,'figures/l1_param_error','png');
saveas(f,'figures/l1_param_error','pdf');

sire_files.H2 = { 'h2-inca_l1h1h2' };

ifo = 3;
for i = 1:length(inj_dirs)
    for j = 1:length(sire_files.(char(ifonames(ifo))))
        
        tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sim_inspiral');
        try
            names = fieldnames(tmp);
            for k = 1:length(names)
                found.(char(ifonames(ifo))).(char(names(k))) = vertcat(found.(char(ifonames(ifo))).(char(names(k))),tmp.(char(names(k))));
            end
        catch
            found.(char(ifonames(ifo))) = tmp;
        end
        
        tmp = readMeta( sprintf( 'injections/%s/%s_missed.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sim_inspiral' );
        try
            names = fieldnames(tmp);
            for k = 1:length(names)
                missed.(char(ifonames(ifo))).(char(names(k))) = vertcat(missed.(char(ifonames(ifo))).(char(names(k))),tmp.(char(names(k))));
            end
        catch
            missed.(char(ifonames(ifo))) = tmp;
        end
        
        tmp = readMeta( sprintf( 'injections/%s/%s_inj_clust.xml', char(inj_dirs(i)), char(sire_files.(char(ifonames(ifo)))(j)) ), 'sngl_inspiral' );
        try
            names = fieldnames(tmp);
            for k = 1:length(names)
                cand.(char(ifonames(ifo))).(char(names(k))) = vertcat(cand.(char(ifonames(ifo))).(char(names(k))),tmp.(char(names(k))));
            end
        catch
            cand.(char(ifonames(ifo))) = tmp;
        end
        
    end
end

found.(char(ifonames(ifo))).mlow=found.(char(ifonames(ifo))).mass2(found.(char(ifonames(ifo))).mass1 > 0.2 & found.(char(ifonames(ifo))).mass2 > 0.2);
found.(char(ifonames(ifo))).mhigh=found.(char(ifonames(ifo))).mass1(found.(char(ifonames(ifo))).mass1 > 0.2 & found.(char(ifonames(ifo))).mass2 > 0.2);
missed.(char(ifonames(ifo))).mlow=missed.(char(ifonames(ifo))).mass2(missed.(char(ifonames(ifo))).mass1 > 0.2 & missed.(char(ifonames(ifo))).mass2 > 0.2);
missed.(char(ifonames(ifo))).mhigh=missed.(char(ifonames(ifo))).mass1(missed.(char(ifonames(ifo))).mass1 > 0.2 & missed.(char(ifonames(ifo))).mass2 > 0.2);
missed.(char(ifonames(ifo))).mchirp = ( (missed.(char(ifonames(ifo))).mass1.*missed.(char(ifonames(ifo))).mass2).^(3/5) ) ./ ...
    ( (missed.(char(ifonames(ifo))).mass1 + missed.(char(ifonames(ifo))).mass2).^(1/5) );
found.(char(ifonames(ifo))).mchirp = ( (found.(char(ifonames(ifo))).mass1.*found.(char(ifonames(ifo))).mass2).^(3/5) ) ./ ...
    ( (found.(char(ifonames(ifo))).mass1 + found.(char(ifonames(ifo))).mass2).^(1/5) );
cand.(char(ifonames(ifo))).eff_distance_corrected = ( cand.(char(ifonames(ifo))).sigmasq ./ ( cand.(char(ifonames(ifo))).snr.^2 - 2 ) ).^(1/2);

s2start = 729273613;
found.l1.t = ( (found.l1.l_end_time+found.l1.l_end_time_ns/1000000000) - s2start );
cand.l1.t = ( (cand.l1.end_time+cand.l1.end_time_ns/1000000000) - s2start );

found.(char(ifonames(ifo))).t = (found.(char(ifonames(ifo))).h_end_time+found.(char(ifonames(ifo))).h_end_time_ns/1000000000) - s2start;
cand.(char(ifonames(ifo))).t = (cand.(char(ifonames(ifo))).end_time+cand.(char(ifonames(ifo))).end_time_ns/1000000000) - s2start;

for ifo = 2:length(ifonames)
    f.(char(ifonames(ifo))) = figure;
    subplot(3,2,1);
    plot(cand.(char(ifonames(ifo))).eff_distance_corrected,found.(char(ifonames(ifo))).eff_dist_h,'x')
    grid on;
    xlabel(sprintf('%s Recovered Effective Distance (Mpc)',char(ifonames(ifo))));
    ylabel(sprintf('%s Injected Effective Distance (Mpc)',char(ifonames(ifo))));
    subplot(3,2,2);
    hist( (cand.(char(ifonames(ifo))).eff_distance_corrected-found.(char(ifonames(ifo))).eff_dist_h) ./ found.(char(ifonames(ifo))).eff_dist_h,50);
    grid on;
    xlabel(sprintf('%s \\Delta D / D',char(ifonames(ifo))));
    ylabel(sprintf('%s Number of Injections',char(ifonames(ifo))));
    subplot(3,2,3);
    plot(cand.(char(ifonames(ifo))).mchirp,found.(char(ifonames(ifo))).mchirp,'x')
    grid on;
    xlabel(sprintf('%s Recovered M_{chirp}',char(ifonames(ifo))));
    ylabel(sprintf('%s Injected M_{chirp}',char(ifonames(ifo))));
    subplot(3,2,4);
    hist((cand.(char(ifonames(ifo))).mchirp-found.(char(ifonames(ifo))).mchirp)./found.(char(ifonames(ifo))).mchirp,50);
    grid on;
    xlabel(sprintf('%s \\Delta M_{chirp} / M_{chirp}',char(ifonames(ifo))));
    ylabel(sprintf('%s Number of Injections',char(ifonames(ifo))));
    subplot(3,2,5);
    plot(cand.(char(ifonames(ifo))).t./3600,found.(char(ifonames(ifo))).t./3600,'x')
    grid on;
    xlabel(sprintf('%s Recovered End Time (hours since 729273613)',char(ifonames(ifo))));
    ylabel(sprintf('%s Injected End Time (hours since 729273613)',char(ifonames(ifo))));
    subplot(3,2,6);
    hist((cand.(char(ifonames(ifo))).t-found.(char(ifonames(ifo))).t)*1000,50);
    grid on;
    xlabel(sprintf('%s \\Delta t',char(ifonames(ifo))));
    ylabel(sprintf('%s Number of Injections',char(ifonames(ifo))));
end

saveas(f.H1,'figures/h1_param_error','pdf');
saveas(f.H1,'figures/h1_param_error','png');
saveas(f.H2,'figures/h2_param_error','pdf');
saveas(f.H2,'figures/h2_param_error','png');
clear f;

f = figure;
subplot(3,1,1);
hist((cand.l1.eff_distance_corrected-found.l1.eff_dist_l)./found.l1.eff_dist_l,50);
grid on;
axis([-0.5 0.5 0 Inf]);
xlabel('L1 \Delta D / D (Mpc)');
ylabel('L1 Number of Injections');
subplot(3,1,2);
hist((cand.H1.eff_distance_corrected-found.H1.eff_dist_h)./found.H1.eff_dist_h,50);
grid on;
axis([-0.5 0.5 0 Inf]);
xlabel('H1 \Delta D / D (Mpc)');
ylabel('H1 Number of Injections');
subplot(3,1,3);
hist((cand.H2.eff_distance_corrected-found.H2.eff_dist_h)./found.H2.eff_dist_h,50);
grid on;
axis([-0.5 0.5 0 Inf]);
xlabel('H2 \Delta D / D (Mpc)');
ylabel('H2 Number of Injections');

saveas(f,'figures/inj_dist_err','png');
saveas(f,'figures/inj_dist_err','pdf');

f = figure;
subplot(3,1,1);
hist((cand.l1.eff_distance-found.l1.eff_dist_l)./found.l1.eff_dist_l,50);
grid on;
axis([-0.5 0.5 0 Inf]);
xlabel('L1 \Delta D^\ast / D^\ast (Mpc)');
ylabel('L1 Number of Injections');
subplot(3,1,2);
hist((cand.H1.eff_distance-found.H1.eff_dist_h)./found.H1.eff_dist_h,50);
grid on;
axis([-0.5 0.5 0 Inf]);
xlabel('H1 \Delta D^\ast / D^\ast (Mpc)');
ylabel('H1 Number of Injections');
subplot(3,1,3);
hist((cand.H2.eff_distance-found.H2.eff_dist_h)./found.H2.eff_dist_h,50);
grid on;
axis([-0.5 0.5 0 Inf]);
xlabel('H2 \Delta D^\ast / D^\ast (Mpc)');
ylabel('H2 Number of Injections');

saveas(f,'figures/inj_diststar_err','png');
saveas(f,'figures/inj_diststar_err','pdf');

clear c mbin n nfound nmissed;
clear tmp sire_files inj_dirs i j k ifo ifonames names;