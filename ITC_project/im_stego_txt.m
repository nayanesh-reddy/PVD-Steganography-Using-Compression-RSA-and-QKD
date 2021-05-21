function txt = im_stego_txt( algorithm ,k,  stego_im_file_name, text_file_name)

    algorithm = string(algorithm);

    % read image
    img = imread(stego_im_file_name);

    s = size(img);
    s = min(s(1:2));
    order = floor(log2(s));

    [PX,PY] = hilbert_fractal_generating(order);

    if algorithm == "PVD"
        txt =  pvd( 'decoding', img, 0, PX, PY );

    elseif algorithm == "kLSB"
        txt = klsb( k, 'decoding', img, 0, PX, PY );

    else
        fprintf("please provide valid alogrithm name\n");
    end

    file_id = fopen(text_file_name,'w');
    fwrite(file_id, txt);
    fclose(file_id);
    
end