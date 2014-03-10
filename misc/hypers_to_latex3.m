function hypers_to_latex3(filename, ...
    ard_lengthscales, ard_variance, ...
    add_lengthscales, add_variances, add_orders, ...
    nicename, print_linear, ard_linear, add_linear )

if nargin < 8
    print_linear = false;
end

file = fopen( filename, 'w');

num_dims = length(ard_lengthscales);

%[pathstr, nicename, ext, versn] = fileparts( dataset_name );
%nicename = latex_safe_str(nicename);

% Print all the usual table header stuff
fprintf(file, '%% --- Automatically generated by hypers_to_latex.m ---\n');
fprintf(file, '%% Exported at %s\n', datestr(now()));
fprintf(file, '\\begin{table}[h]\n');
fprintf(file, '\\caption{{\\small\n');
fprintf(file, 'Hyperparameters for %s dataset.\n', nicename );
fprintf(file, '}}\n');
fprintf(file, '\\label{tbl:%s}\n', nicename);
%fprintf(      '\\ref{tbl:%s}\n', nicename);
fprintf(file, '\\begin{center}\n');
fprintf(file, '\\begin{tabular}{r |%s}\n', repmat(' r', 1, num_dims));

% first line
feature_names = {'cement','slag','ash','water','plast.','coarse','fine','age','strength'};
fprintf(file, 'Variable:');
for ii = 1:num_dims
    if strcmp(nicename, 'concrete')
        fprintf( file, ' & %s ', feature_names{ii} );
    else
        fprintf(file, ' & $x_%d$ ', ii);
    end
end
%fprintf(file, ' & Total Variance ');
fprintf(file, ' \\\\ \\hline\n');

fprintf(file, 'Sq-exp lengthscale');
for ii = 1:num_dims
  fprintf(file, ' & $%4.2f$ ', ard_lengthscales(ii));
end
%fprintf(file, ' & $%4.2f$ ', ard_variance );
fprintf(file, ' \\\\ \n');

if print_linear
    fprintf(file, 'ARD linear');
    for ii = 1:num_dims
      fprintf(file, ' & $%4.2f$ ', ard_linear(ii));
    end
    %fprintf(file, ' & $%4.2f$ ', ard_variance );
    fprintf(file, ' \\\\ \n');
end

fprintf(file, '\\hline\n');

fprintf(file, 'Additive lengthscale');
for ii = 1:num_dims
  fprintf(file, ' & $%4.2f$ ', add_lengthscales(ii));
end
%fprintf(file, ' & ');
fprintf(file, ' \\\\\n');

if print_linear
    fprintf(file, 'ADD Linear');
    for ii = 1:num_dims
      fprintf(file, ' & $%4.2f$ ', add_linear(ii));
    end
    %fprintf(file, ' & $%4.2f$ ', ard_variance );
    fprintf(file, ' \\\\ \n');
end

if add_variances ~= []
    fprintf(file, 'ADD Variance');
    for ii = 1:num_dims
      fprintf(file, ' & $%4.2f$', add_variances(ii));
    end
    %fprintf(file, ' & $%4.2f$ ', sum(add_variances) );
    %fprintf(file, ' & ');
    fprintf(file, ' \\\\ \\hline\n');
end
fprintf(file, '\\hline\n');
%order_words = {'1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th'
fprintf(file, 'Order of interaction:');
for ii = 1:length(add_orders)
  fprintf(file, ' & \\nth{%i}', ii);
end
%fprintf(file, ' & ');
fprintf(file, ' \\\\\n');

fprintf(file, 'Additive order variance');
for ii = 1:length(add_orders)
  fprintf(file, ' & $%3.1f$\\%%', add_orders(ii) / sum(add_orders) * 100);
end
%fprintf(file, ' & $%4.2f$ ', sum(add_orders) );
fprintf(file, ' \\\\ \\hline\n');

fprintf(file, '\\end{tabular}\n');
fprintf(file, '\\end{center}\n');
fprintf(file, '\\end{table}\n');
fprintf(file, '%% End automatically generated LaTeX\n');

fclose(file);