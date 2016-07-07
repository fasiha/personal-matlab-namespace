function y = shuffle(x)
i = randperm(numel(x));
y = reshape(x(i), size(x));
