classdef flanger_MangeshSonawane_s1889125_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        PlayoriginalsoundButton  matlab.ui.control.Button
        PlayflangersoundButton   matlab.ui.control.Button
        M0valuesKnobLabel        matlab.ui.control.Label
        M0valuesKnob             matlab.ui.control.Knob
        DvaluesKnobLabel         matlab.ui.control.Label
        DvaluesKnob              matlab.ui.control.Knob
        gvaluesKnobLabel         matlab.ui.control.Label
        gvaluesKnob              matlab.ui.control.Knob
    end

    methods (Access = private)

        % Button pushed function: PlayoriginalsoundButton
        function PlayoriginalsoundButtonPushed(app, event)
            [x,Fs]=audioread('Cath_Very_Short2.wav');
            soundsc(x,Fs);
        end

        % Button pushed function: PlayflangersoundButton
        function PlayflangersoundButtonPushed(app, event)
            [x,Fs]=audioread('Cath_Very_Short2.wav');
            LEN=length(x);
            
            M01=app.M0valuesKnob.Value;
            D1=app.DvaluesKnob.Value;
            g1=app.gvaluesKnob.Value;
            
            M0=round((M01/1000)*Fs);
            
            D=round((D1/1000)*Fs);
            f1=0.2;
            
            N=2;
           Q=6;
           for i=1:Q
    alp(i)=(-((Q/2) -(i-1))/Q);   %value of alpha between -1/2 to 1/2    
     X(i)=(-((Q/2) -(i-1))/Q);    %value of alpha between -1/2 to 1/2    
    
end
%Initialise output 
coefficient=ones(length(X),N);
for k=1:length(X)
  for i=1:N
    for j=1:N
        if j~=i
           coefficient(k,j)=coefficient(k,j).*((alp(k)-X(j))./(X(i)-X(j)));
        end
    end
  end
 
end
 %Output table of coefficient 
 coefficient;
 %End stopwatch
 
      
    Ts=1/Fs;
 
 PolyInterpolate1=zeros(length(x),1);
y=zeros(LEN,1);
 y(1:M0)=x(1:M0);
 
 
 for n=M0+1:(LEN)
%--------------------------------------------------------------------------------------%
%--------------------------------------------------------------------------------------%
  %Implementation for LFO 1
%--------------------------------------------------------------------------------------%
%--------------------------------------------------------------------------------------%  
    
  %Calculation of M1=D1+M0*sin(2*pi*f1*n*Ts)
   M1(n) =(M0*(sin(2*pi*n*f1*Ts)));
   M1(n)= ((M1(n))+D);
  %calculation of n-M1
   delta1(n)=n-M1(n);
   
   if delta1(n)-N/2>1
   %Initially value of window for interpolation is consideres as floor of
   %delta
       fdelta1=floor(delta1(n));
         for i=1:N/2
             %Here window means the values to interpolated i.e. if 5.2 is to
             %be interpolated about N=4 then finalwindow will be  (4,5,6,7)
             %Hence window is for the values below floor(delta) and
               %window3 is for the values above floor(delta)
              %Calculation of value for window below floor(delta) 
                window(i)=fdelta1+i;
              %Calculation of value for window above floor(delta)
                window2(i)=fdelta1-i+1;
                window3=flip(window2);
              %Final window to be interpolated for smooth effect
                finalwindow=[window3 window];   %These are polynomial variables 
         end
   %Calculation of alpha
    alpha=delta1(n)-fdelta1-0.5;
    %Initialise index as 0 .This index will be used to compare with the coefficient table
    index1=0;
    difference=abs(alp-alpha);
    minvalue=min(difference);
    %This is the index of row to be used to get the values of coefficient
    %from the coefficient table of lagrange interpolation
    index1 = find(difference==minvalue);
          for z=1:N
              %Checks if the values are non negative for x(n-M1) and must
              %be within the length of input sigal
              if ((finalwindow>0) & (finalwindow<=LEN))==true
                  %These are the interpolated values for x(n-M1) to be interpolated using the
                  %formula of P(n)=summation of (x(window)*Coefficient)
                 PolyInterpolate1(n)=PolyInterpolate1(n)+(coefficient(index1,z))*x(finalwindow(z));
              end
              y(n)=x(n)+(PolyInterpolate1(n))*g1;
          end

   end
 end
   
    
 
    soundsc(y,Fs);
    
        end

        % Value changed function: M0valuesKnob
        function M0valuesKnobValueChanged(app, event)
            value = app.M0valuesKnob.Value;
            
        end

        % Value changed function: DvaluesKnob
        function DvaluesKnobValueChanged(app, event)
            value = app.DvaluesKnob.Value;
            
        end

        % Value changed function: gvaluesKnob
        function gvaluesKnobValueChanged(app, event)
            value = app.gvaluesKnob.Value;
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create PlayoriginalsoundButton
            app.PlayoriginalsoundButton = uibutton(app.UIFigure, 'push');
            app.PlayoriginalsoundButton.ButtonPushedFcn = createCallbackFcn(app, @PlayoriginalsoundButtonPushed, true);
            app.PlayoriginalsoundButton.Position = [65.5 135 117 22];
            app.PlayoriginalsoundButton.Text = 'Play original sound';

            % Create PlayflangersoundButton
            app.PlayflangersoundButton = uibutton(app.UIFigure, 'push');
            app.PlayflangersoundButton.ButtonPushedFcn = createCallbackFcn(app, @PlayflangersoundButtonPushed, true);
            app.PlayflangersoundButton.Position = [411.5 135 115 22];
            app.PlayflangersoundButton.Text = 'Play flanger sound';

            % Create M0valuesKnobLabel
            app.M0valuesKnobLabel = uilabel(app.UIFigure);
            app.M0valuesKnobLabel.HorizontalAlignment = 'center';
            app.M0valuesKnobLabel.Position = [93 299 60 22];
            app.M0valuesKnobLabel.Text = 'M0 values';

            % Create M0valuesKnob
            app.M0valuesKnob = uiknob(app.UIFigure, 'continuous');
            app.M0valuesKnob.Limits = [11 39];
            app.M0valuesKnob.ValueChangedFcn = createCallbackFcn(app, @M0valuesKnobValueChanged, true);
            app.M0valuesKnob.Position = [92 355 60 60];
            app.M0valuesKnob.Value = 29;

            % Create DvaluesKnobLabel
            app.DvaluesKnobLabel = uilabel(app.UIFigure);
            app.DvaluesKnobLabel.HorizontalAlignment = 'center';
            app.DvaluesKnobLabel.Position = [306.5 297 52 22];
            app.DvaluesKnobLabel.Text = 'D values';

            % Create DvaluesKnob
            app.DvaluesKnob = uiknob(app.UIFigure, 'continuous');
            app.DvaluesKnob.Limits = [1 9];
            app.DvaluesKnob.ValueChangedFcn = createCallbackFcn(app, @DvaluesKnobValueChanged, true);
            app.DvaluesKnob.Position = [302 353 60 60];
            app.DvaluesKnob.Value = 3;

            % Create gvaluesKnobLabel
            app.gvaluesKnobLabel = uilabel(app.UIFigure);
            app.gvaluesKnobLabel.HorizontalAlignment = 'center';
            app.gvaluesKnobLabel.Position = [506.5 299 50 22];
            app.gvaluesKnobLabel.Text = 'g values';

            % Create gvaluesKnob
            app.gvaluesKnob = uiknob(app.UIFigure, 'continuous');
            app.gvaluesKnob.Limits = [0 0.9];
            app.gvaluesKnob.MajorTicks = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
            app.gvaluesKnob.ValueChangedFcn = createCallbackFcn(app, @gvaluesKnobValueChanged, true);
            app.gvaluesKnob.MinorTicks = [];
            app.gvaluesKnob.Position = [501 355 60 60];
            app.gvaluesKnob.Value = 0.3;
        end
    end

    methods (Access = public)

        % Construct app
        function app = flanger_MangeshSonawane_s1889125_GUI

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
