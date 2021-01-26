function [func] = y_func(th1, th2, x_s, y_s)

func = sqrt(((th1 - x_s).^2) + ((th2 - y_s).^2)); 

end
