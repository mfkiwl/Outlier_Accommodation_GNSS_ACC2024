function [state, cov] = obtainInitEkfStateAndCov(p, estState)

% position, velocity, acceleration,
% clock biases (m), clock drift (m/s)
if p.state_mode == p.pva_mode
    state = [estState.pos;estState.vel;zeros(3, 1)];
    cov_diag = p.ekf_para.q_pos^2 * ones(1,9);
elseif p.state_mode == p.pos_mode
    state = [estState.pos;estState.clock_bias;0];
    cov_diag = p.ekf_para.q_pos^2 * ones(1,3);
end

if ~isnan(estState.clock_sys(p.gps.sys_num))
    state = [state; estState.clock_sys(p.gps.sys_num)];
    cov_diag = [cov_diag, 40^2];
end
if ~isnan(estState.clock_sys(p.glo.sys_num))
    state = [state; estState.clock_sys(p.glo.sys_num)];
    cov_diag = [cov_diag, 40^2];
end
if ~isnan(estState.clock_sys(p.gal.sys_num))
    state = [state; estState.clock_sys(p.gal.sys_num)];
    cov_diag = [cov_diag, 40^2];
end
if ~isnan(estState.clock_sys(p.bds.sys_num))
    state = [state; estState.clock_sys(p.bds.sys_num)];
    cov_diag = [cov_diag, 40^2];
end

state = [state; estState.clock_drift];
cov_diag = [cov_diag, 5^2];
cov = diag(cov_diag);
