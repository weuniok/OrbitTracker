function C = StumpffC(z)

if z > 0
    C = (1 - cos(sqrt(z))) / z;
elseif z < 0
    C = (cosh(sqrt(-z)) - 1) / (-z);
else
    C = 0.5;
end

end

