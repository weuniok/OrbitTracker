function S = StumpffS(z)
%STUMPFFS calculates Stumpff C coefficient

if z > 0
    S = (sqrt(z) - sin(sqrt(z))) / (sqrt(z))^3;
elseif z < 0
    S = (sinh(sqrt(-z)) - sqrt(-z)) / (sqrt(-z))^3;
else
    S = 1/6;
end

end
