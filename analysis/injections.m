% $Id$

clear;

inj_dirs = { '2004062102_thesis_run_inj_4575','2004062103_thesis_run_inj_2375',...
        '2004062104_thesis_run_inj_2501','2004062105_thesis_run_inj_1945' };

sire_files.l1 = { 'l1-inca_l1h1h2', 'l1-inca_l1h1', 'l1-inca_l1h2' };
sire_files.h1 = { 'h1-inca_l1h1h2', 'h1-inca_l1h1' };
sire_files.h2double = { 'h2-inca_l1h2' };

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
end

s2start = 729273613;
found.l1.t = ( (found.l1.l_end_time+found.l1.l_end_time_ns/1000000000) - s2start );
cand.l1.t = ( (cand.l1.end_time+cand.l1.end_time_ns/1000000000) - s2start );

for ifo = 2:length(ifonames)
    found.(char(ifonames(ifo))).t = (found.(char(ifonames(ifo))).h_end_time+found.(char(ifonames(ifo))).h_end_time_ns/1000000000) - s2start;
    cand.(char(ifonames(ifo))).t = (cand.(char(ifonames(ifo))).end_time+cand.(char(ifonames(ifo))).end_time_ns/1000000000) - s2start;
end


figure;
scatter(missed.h1.mass1,missed.h1.mass2,50,missed.h1.eff_dist_h,'^','filled');
c = colorbar;
set(get(c,'XLabel'),'String','D (Mpc)')
vline(0.2);
hline(0.2);
xlabel('Mass 1');
ylabel('Mass 2');
title('Triple and L1H1 Double Coincident Missed MACHO Injections');

figure;
scatter(found.h1.mass1,found.h1.mass2,50,found.h1.eff_dist_h,'o','filled');
c = colorbar;
set(get(c,'XLabel'),'String','D (Mpc)')
vline(0.2);
hline(0.2);
xlabel('Mass 1');
ylabel('Mass 2');
title('Triple and L1H1 Double Coincident Found MACHO Injections');

%figure;
%scatter(missed.h2double.mass1,missed.h2double.mass2,50,missed.h2double.eff_dist_h,'^','filled');
%c = colorbar;
%set(get(c,'XLabel'),'String','D (Mpc)')
%vline(0.2);
%hline(0.2);
%xlabel('Mass 1');
%ylabel('Mass 2');
%title('L1H2 Double Coincident Missed MACHO Injections');

%figure;
%scatter(found.h2double.mass1,found.h2double.mass2,50,found.h2double.eff_dist_h,'o','filled');
%c = colorbar;
%set(get(c,'XLabel'),'String','D (Mpc)')
%vline(0.2);
%hline(0.2);
%xlabel('Mass 1');
%ylabel('Mass 2');
%title('L1H2 Double Coincident Found MACHO Injections');

%found.h1.mlow=min(found.h1.mass1,found.h1.mass2);
%found.h1.mhigh=max(found.h1.mass1,found.h1.mass2);
%missed.h1.mlow=min(missed.h1.mass1,missed.h1.mass2);
%missed.h1.mhigh=max(missed.h1.mass1,missed.h1.mass2);


figure;
plot(missed.h1.mlow(missed.h1.mlow>0.2),missed.h1.mhigh(missed.h1.mlow>0.2),'rx',...
    found.h1.mlow(found.h1.mlow>0.2),found.h1.mhigh(found.h1.mlow>0.2),'b+');
vline(0.2);
hline(0.2);
xlabel('Mass 1');
ylabel('Mass 2');
title('Triple and L1H1 Double Coincident Missed MACHO Injections');

mbin=(0.2:0.025:1.0);
n=histc([missed.h1.mhigh(missed.h1.mlow>0.2); found.h1.mhigh(found.h1.mlow>0.2)],mbin);
nmissed=histc(missed.h1.mhigh(missed.h1.mlow>0.2),mbin);
nfound=histc(found.h1.mhigh(found.h1.mlow>0.2),mbin);

figure;
subplot(2,1,1);
bar(mbin,nmissed./n,'histc','r');
title('H1 MACHO Playground Injections');
xlabel('solar masses');
ylabel('1 - \epsilon');
legend('Missed');
grid on;
axis([0.2 1 0 1.1]);
subplot(2,1,2);
bar(mbin,nfound./n,'histc','b');
xlabel('solar masses');
ylabel('\epsilon');
legend('Found');
grid on;
axis([0.2 1 0 1.1]);

mbin=(0.1741:0.0348:0.8706);
n=histc([missed.h1.mchirp(missed.h1.mchirp>0.1741); found.h1.mchirp(found.h1.mchirp>0.1741)],mbin);
nmissed=histc(missed.h1.mchirp(missed.h1.mchirp>0.1741),mbin);
nfound=histc(found.h1.mchirp(found.h1.mchirp>0.1741),mbin);

figure;
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


figure;
plot(found.h1.mchirp,found.h1.eff_dist_h,'b+',missed.h1.mchirp,missed.h1.eff_dist_h,'rx');
xlabel('Chirp Mass');
ylabel('H Effective Distance');
title('H1 Triple and L1H1 Double Coincident Found MACHO Injections');


figure;
subplot(3,2,1);
plot(cand.l1.eff_distance,found.l1.eff_dist_l,'x')
grid on;
xlabel('Recovered Effective Distance (Mpc)');
ylabel('Injected Effective Distance (Mpc)');
subplot(3,2,2);
hist(cand.l1.eff_distance-found.l1.eff_dist_l,50);
grid on;
xlabel('Error in Recovered Effective Distance (Mpc)');
ylabel('Number of Injections');
subplot(3,2,3);
plot(cand.l1.mchirp,found.l1.mchirp,'x')
grid on;
xlabel('Recovered Chirp Mass');
ylabel('Injected Chirp Mass');
subplot(3,2,4);
hist(cand.l1.mchirp-found.l1.mchirp,50);
grid on;
xlabel('Error in Recovered Chirp Mass');
ylabel('Number of Injections');
subplot(3,2,5);
plot(cand.l1.t./3600,found.l1.t./3600,'x')
grid on;
xlabel('Recovered End Time (hours since 729273613)');
ylabel('Injected End Time (hours since 729273613)');
subplot(3,2,6);
hist((cand.l1.t-found.l1.t)*1000,50);
grid on;
xlabel('Error in Recovered End Time (ms)');
ylabel('Number of Injections');

for ifo = 2:length(ifonames)
    figure;
    subplot(3,2,1);
    plot(cand.(char(ifonames(ifo))).eff_distance,found.(char(ifonames(ifo))).eff_dist_h,'x')
    grid on;
    xlabel('Recovered Effective Distance (Mpc)');
    ylabel('Injected Effective Distance (Mpc)');
    subplot(3,2,2);
    hist(cand.(char(ifonames(ifo))).eff_distance-found.(char(ifonames(ifo))).eff_dist_h,50);
    grid on;
    xlabel('Error in Recovered Effective Distance (Mpc)');
    ylabel('Number of Injections');
    subplot(3,2,3);
    plot(cand.(char(ifonames(ifo))).mchirp,found.(char(ifonames(ifo))).mchirp,'x')
    grid on;
    xlabel('Recovered Chirp Mass');
    ylabel('Injected Chirp Mass');
    subplot(3,2,4);
    hist(cand.(char(ifonames(ifo))).mchirp-found.(char(ifonames(ifo))).mchirp,50);
    grid on;
    xlabel('Error in Recovered Chirp Mass');
    ylabel('Number of Injections');
    subplot(3,2,5);
    plot(cand.(char(ifonames(ifo))).t./3600,found.(char(ifonames(ifo))).t./3600,'x')
    grid on;
    xlabel('Recovered End Time (hours since 729273613)');
    ylabel('Injected End Time (hours since 729273613)');
    subplot(3,2,6);
    hist((cand.(char(ifonames(ifo))).t-found.(char(ifonames(ifo))).t)*1000,50);
    grid on;
    xlabel('Error in Recovered End Time (ms)');
    ylabel('Number of Injections');
end

clear c mbin n nfound nmissed;
clear tmp sire_files inj_dirs i j k ifo ifonames names;
