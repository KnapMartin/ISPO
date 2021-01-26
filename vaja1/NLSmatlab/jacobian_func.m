function [jac] = jac_func(th1, th2, x, y)

dr_dth1 = (2.*th1 - 2.*x)./(2.*((th1 - x).^2 + (th2 - y).^2).^(1./2));
dr_dth2 = (2.*th2 - 2.*y)./(2.*((th1 - x).^2 + (th2 - y).^2).^(1./2));

jac = [dr_dth1, dr_dth2];
end