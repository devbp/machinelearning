function y = f(x)
%activation function for neuron activation update, set to Tanh(x)or
%identity or any other invertible sigmoid you want
y = tanh(x);
%y=1/(1+exp(-x));
%  y = x;