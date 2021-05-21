function stego_img = txt_stego_im( algorithm , k, img_file_name, text_file_name, stego_im_file_name)

    algorithm = string(algorithm);

    % read image
    img = imread(img_file_name);

    % read text file
    file_id = fopen(text_file_name,'r');
    file_content = fread(file_id);
    fclose(file_id);

    in = dec2bin(file_content',8)';
    in = in(:)';

    s = size(img);
    s = min(s(1:2));
    order = floor(log2(s));

    [PX,PY] = hilbert_fractal_generating(order);

    if algorithm == "PVD"
        stego_img =  pvd( 'encoding', img, in, PX, PY );

    elseif algorithm == "kLSB"
        stego_img = klsb( k, 'encoding', img, in, PX, PY );

    else
        fprintf("please provide valid alogrithm name\n");
    end

    imwrite( stego_img, stego_im_file_name)
    
end