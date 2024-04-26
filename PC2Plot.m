clear
clc
close all
% Solve DE numerically using ode45
m_num   = -1;
b_num = 5;
l_num = 3;
h_num = 10;
k_num = 1;
m_b_num = 0.5;
m_c_num = 0.5;
S_num = 2;
theta_num = atan(-m_num);
g_num   = 9.81;
tspan   = [0 20];
Y0      = [-2 0 pi/4 0];
options = odeset('RelTol',1e-6);
% Use created .m file to solve DE 
[t, Y]  = ode45(@PC2_sys,tspan,Y0,options,m_num,b_num,l_num,h_num,k_num,m_b_num,m_c_num,g_num,S_num);

% Position vectors
r_c = @(rz)[rz*cos(theta_num);b_num-rz*sin(theta_num)];
r_b = @(rz, phi) [rz*cos(theta_num)+h_num*sin(theta_num)+l_num*sin(phi-theta_num);b_num-rz*sin(theta_num)+h_num*cos(theta_num)-l_num*cos(phi-theta_num)];
% r_k = @(rz) [rz*cos(theta_num)+b_num/m_num;b_num-rz*sin(theta_num)];
r_z = @(rz) [rz*cos(theta_num);-rz*sin(theta_num)];
lineFun = @(xx) (m_num * xx + b_num);

% Draw the figure
figure

% Plot options (change if necessary)
DEBUG = false;
PLOT_POS_VECTORS = false;
axis('equal');


n_points = length(Y(:,1))
for k=1:n_points
    % Wipe the slate clean
    clf

    % Plot inclined plane
    line_x = linspace(-30, 30, n_points);
    line_y = lineFun(line_x);
    plot(line_x, line_y, 'k', 'LineWidth', 3)
    

    % Calculate position vectors
    posC = r_c(Y(k,1));
    posB = r_b(Y(k,1), Y(k,3));

    
    % Body C
    hold on
    % plot(posC(1), posC(2), 's', 'MarkerSize', 30, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', '#BBBBBB')

    % Draw stick of height h_num and width w_stick
    w_stick = 0.25;
    A_1 = [posC(1) - w_stick; lineFun(posC(1) - w_stick)];
    A_2 = [posC(1) + w_stick; lineFun(posC(1) + w_stick)];
    B_1 = A_1 + h_num * [sin(theta_num); cos(theta_num)];
    B_2 = A_2 + h_num * [sin(theta_num); cos(theta_num)];
    hold on
    fill([A_1(1) B_1(1) B_2(1) A_2(1)], [A_1(2) B_1(2) B_2(2) A_2(2)], 'black', 'FaceAlpha', 0.3);

    % Draw string of length l between the middle of the stick and rB
    plot([(B_1(1) + B_2(1))/2, posB(1)], [(B_1(2) + B_2(2))/2, posB(2)], 'black', 'LineWidth', 2)
    
    % Draw rectangle
    w_rect = 2;
    h_rect = 3;
    A_1 = [posC(1) - w_rect; lineFun(posC(1) - w_rect)];
    A_2 = [posC(1) + w_rect; lineFun(posC(1) + w_rect)];
    B_1 = A_1 + h_rect * [sin(theta_num); cos(theta_num)];
    B_2 = A_2 + h_rect * [sin(theta_num); cos(theta_num)];
    hold on
    fill([A_1(1) B_1(1) B_2(1) A_2(1)], [A_1(2) B_1(2) B_2(2) A_2(2)], [0.6 0.6 0.6]);

    % Draw spring
    NE = 10;
    NR = k_num;
    [x_spring, y_spring] = spring((A_2(1) + B_2(1)) / 2, (A_2(2) + B_2(2)) / 2, -b_num/m_num, 0, NE, S_num, NR);
    plot(x_spring,y_spring,'black','LineWidth',2);
    
    
    % Body B
    hold on
    
    circles(posB(1), posB(2), 0.5, 'color', 'black', 'FaceAlpha', 0.4);

    

    if (PLOT_POS_VECTORS)
        quiver(0, 0, posC(1), posC(2), 'Color', '#0072BD', 'LineWidth', 2);
        quiver(0, 0, posB(1), posB(2), 'Color', '#7E2F8E', 'LineWidth', 2);
    end

    
    
    if (DEBUG)
        % r0 vector
        hold on
        quiver(0, 0, -b_num/m_num, 0, 'Color', '#A2142F', 'LineWidth', 2);

        % rk vector
        % posK = r_k(Y(k,1));
        % hold on
        % quiver(-b_num/m_num, 0, posK(1), posK(2), 'Color', '#EDB120', 'LineWidth', 2);

        % ry vector
        hold on
        posY = [0;b_num];
        quiver(0, 0, posY(1), posY(2), 'Color', '#77AC30', 'LineWidth', 2);

        % rz vector
        posZ = r_z(Y(k,1));
        hold on
        quiver(posY(1), posY(2), posZ(1), posZ(2), 'Color', '#00FFFF', 'LineWidth', 2);
    end
    
    
    % Decorate the plot
    grid on
    xlabel('x')
    ylabel('y')
    title(["Particle at frame ", k])

    % Force matlab to draw the image
    drawnow
end

