clc;clear all; close all;
func = @(x) (1.306*4.39499e-8*x*((5^3.5) / sqrt(4.5))*(4.23333e-4*4.5*x - 13.6)) - 2.5;
st=0;
sp=5000000;
tol=1e-6;
bisection(func,st,sp,tol)
function res = bisection(func, start, stop, errtol)
    max_iter = 1 + round(log((stop - start) / errtol) / log(2));
    for i = 1: max_iter
        midpoint = (start + stop) / 2;
        if func(start) * func(midpoint) < 0
            stop = midpoint;
        elseif func(start) * func(midpoint) > 0
            start = midpoint;
        else 
            res = midpoint;
            break
        end
    end
    res = midpoint;
end