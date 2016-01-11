
%% load data

addpath('..');addpath('../..');

inputNum = input('number of iteration : ');

load data
load data_label
load data_test
load data_test_label


%%

index = randperm(size(data,1));
X = data(index(1:end),:);
X_labels = data_label(index(1:end),:);


X_labels = X_labels + 1;

%% load test data

X_test = data_test;
X_test_labels = data_test_label;


X_test_labels = X_test_labels + 1;

%% data normalization
mu = mean(X,1);
sigma = std(X,1);
sigma(find(sigma==0)) = 1;

X=bsxfun(@rdivide, bsxfun(@minus, X, mu),sigma);
X_test=bsxfun(@rdivide, bsxfun(@minus, X_test, mu),sigma);

%% shuffle the training data


perm_idx = randperm (size(X,1));

n_all = size(X, 1);
n_train = ceil(n_all * 3 / 4);
n_valid = floor(n_all /4);

X_valid = X(perm_idx(n_train+1:end), :);
X_valid_labels = X_labels(perm_idx(n_train+1:end));
X = X(perm_idx(1:n_train), :);
X_labels = X_labels(perm_idx(1:n_train));




%% mlp structure

layers = [size(X,2), 177, 2];
n_layers = length(layers);
blayers = [1, 1, 1];

use_tanh = 2;
do_pretrain = 0;


M = default_mlp (layers);

M.output.binary = blayers(end);
M.hidden.use_tanh = use_tanh;

M.valid_min_epochs = 40;
M.dropout.use = 1;

% M.hook.per_epoch = {@save_intermediate, {'mlp_mnist.mat'}};

M.learning.lrate = 1e-3;
M.learning.lrate0 = 5000;
M.learning.minibatch_sz = 128;

M.adadelta.use = 1;
M.adadelta.epsilon = 1e-8;
M.adadelta.momentum = 0.99;

M.noise.drop = 0;
M.noise.level = 0;


 M.iteration.n_epochs = inputNum;
% M.iteration.n_epochs = 13;



fprintf(1, 'Training MLP\n');
tic;
M = mlp(M, X, X_labels, X_valid, X_valid_labels, 0.1);
fprintf(1, 'Training is done after %f seconds\n', toc);

M.mu = mu;
M.sigma = sigma;
%% test
[pred] = mlp_classify (M, X);
n_correct = sum(X_labels == pred);

fprintf(1, 'Correctly classified train samples: %d/%d\n', n_correct, size(X, 1));
train_accu = 100*n_correct/ size(X, 1);

[pred] = mlp_classify (M, X_test);
n_correct = sum(X_test_labels == pred);

fprintf(1, 'Correctly classified test samples: %d/%d\n', n_correct, size(X_test, 1));
test_accu = 100*n_correct/ size(X_test, 1);

disp([num2str(train_accu), ' %   vs   ', num2str(test_accu),' %']);



 save M M
 save X X
 save X_labels X_labels
 save X_valid X_valid
 save X_valid_labels X_valid_labels
 save X_test X_test
 save X_test_labels X_test_labels

 %% for new data(new song)
% load data_test
% load data_test_label
% load M
% 
% X_test = data_test;
% X_test_labels = data_test_label;
% X_test_labels = X_test_labels + 1;
% mu = M.mu; sigma = M.sigma;
% X_test=bsxfun(@rdivide, bsxfun(@minus, X_test, mu),sigma);
% 
%  save X_test X_test
%  save X_test_labels X_test_labels 
