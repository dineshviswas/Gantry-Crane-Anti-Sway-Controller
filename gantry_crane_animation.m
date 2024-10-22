%Animating the Gantry Crane system

%Solve for the states
t = 0:0.01:10;  % Time vector from 0 to 10 seconds, with 0.01s intervals
f_input = 1*(t>=0.5);  % Input force applied at t = 1 second, magnitude = 1N

[y, t, x] = lsim(system_cl, f_input, t, x0); %x contains the state variables

%Setup the animation environment
figure;
axis([-2 2 -2 1.5]);
hold on;
grid on;

plot([-2 2], [0 0], 'LineWidth', 3); %Ground
%Create the trolley
width = 0.3;
height = 0.15;
trolley = rectangle('Position', [x(1,1)-width/2, 0, width, height], 'FaceColor', "r");

% Create pendulum using line
pendulum_x = x(1,1) + l * sin(x(1,3));  % Pendulum's x-coordinate
pendulum_y = -l * cos(x(1,3));  % Pendulum's y-coordinate
pendulum = line([x(1,1) pendulum_x], [height pendulum_y], 'LineWidth', 2, 'Color', 'r');


% Pendulum mass (as a circle)
hMass = plot(pendulum_x, pendulum_y, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);

%Animate the system

% Create a VideoWriter object
v = VideoWriter('gantry_crane_animation', 'MPEG-4');  % Save as an MP4 file
v.FrameRate = 24;
open(v);

%Animation loop
for i = 1:length(t)
    %Update cart position
    set(trolley, 'Position', [x(i, 1)-(width/2), 0, width, height]);
    %Update pendulum positon
    pendulum_x = x(i,1) + l * sin(x(i,3));
    pendulum_y = -l * cos(x(i,3));
    set(pendulum, 'XData', [x(i,1) pendulum_x], 'YData', [height pendulum_y]);
    %Update payload position
    set(hMass, 'XData', pendulum_x, 'YData', pendulum_y);

    % Capture the current frame for the video
    frame = getframe(gcf);  % Capture the current figure window
    writeVideo(v, frame);   % Write the frame to the video file

    pause(0.005);
end
close(v);