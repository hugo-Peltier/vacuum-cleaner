function run_test(varargin)

p = inputParser;
addParameter(p,'model','vacuum_cleaner');
addParameter(p,'random',false);
parse(p,varargin{:});
opt = p.Results;

run('init_mobile_robotics.m');

if opt.random
    roomHalf = 0.5 * roomL;
    ok = false;
    while ~ok
        x0 = -roomHalf + 2*roomHalf*rand;
        y0 = -roomHalf + 2*roomHalf*rand;
        th0 = -pi + 2*pi*rand;
        ok = ( (x0-obs.center(1))^2 + (y0-obs.center(2))^2 ) > obs.radius^2;
    end
    X0 = [x0 y0 th0];
    assignin('base','X0',X0);
end

mdl = opt.model;
load_system(mdl);
set_param(mdl,'StopTime',num2str(Tsim));
sim(mdl);

assert(exist('x','var')==1 && exist('y','var')==1);

t = (0:length(x)-1)' * Ts;

xs = grid.xmin + (0:grid.N-1) * grid.res;
ys = grid.ymin + (0:grid.N-1) * grid.res;
[XX,YY] = meshgrid(xs,ys);
insideObs = (XX-obs.center(1)).^2 + (YY-obs.center(2)).^2 <= obs.radius^2;
maskValid = ~insideObs;
netArea = roomL^2 - pi*obs.radius^2;

covered = false(grid.N);
xi = round((x - xs(1))/grid.res) + 1;
yi = round((y - ys(1))/grid.res) + 1;
valid = xi>=1 & xi<=grid.N & yi>=1 & yi<=grid.N;
covered(sub2ind(size(covered), yi(valid), xi(valid))) = true;

sweepW = 0.30;
dilatePx = ceil(0.5*sweepW / grid.res);
if dilatePx > 0
    se = strel('disk',dilatePx,0);
    covered = imdilate(covered,se);
end
covered = covered & maskValid;

lin = sub2ind(size(covered), yi(valid), xi(valid));
nPts = min(numel(lin), 800);
idxs = unique(round(linspace(1, numel(lin), nPts)));
covCurve = zeros(numel(idxs),1);
tCurve   = zeros(numel(idxs),1);
step = false(size(covered));

for k = 1:numel(idxs)
    step(lin(1:idxs(k))) = true;
    stepNow = step;
    if dilatePx>0, stepNow = imdilate(step,se); end
    stepNow = stepNow & maskValid;
    covCurve(k) = 100 * (nnz(stepNow) * grid.res^2) / netArea;
    tCurve(k) = t(idxs(k));
end

figure('Name','Trajectoire & zone nettoyée'); hold on; axis equal
imagesc(xs, ys, flipud(covered)); set(gca,'YDir','normal');
colormap(gray);

th = linspace(0,2*pi,200);
plot(obs.center(1)+obs.radius*cos(th), obs.center(2)+obs.radius*sin(th),'r','LineWidth',1.5);
plot(x,y,'b','LineWidth',1.8);
xlabel('x [m]'); ylabel('y [m]');
grid on

figure('Name','% nettoyé vs temps');
plot(tCurve, covCurve, 'LineWidth',1.8);
xlabel('Temps [s]'); ylabel('Surface nettoyée [%]');
ylim([0,100]); grid on;

end
