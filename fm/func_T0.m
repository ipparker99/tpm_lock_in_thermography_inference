function [outputArg1,outputArg2] = func_T0(x,params,option)

arguments
    x       % independent variables being optimized, size (n,)
    params  % additional parameters size (n,)
    options % 
end

if option.fitvars == "heat spot"
    % x = [rx,ry], where rx and ry are heat spot radius in x and y
    % direction respectively
    input = 
    if option.inf_sub == true
        T0hat_infinite(input(:))
    else
        T0hat = T0hat_finite(input);
        T0 = T0hat_to_T0(X,Y,dx,Lth,T0hat);
    end
end


end