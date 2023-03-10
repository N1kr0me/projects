import cv2
import dlib
from scipy.spatial import distance
def calculate_EAR(eye): ##function to calculate the aspect ratio
    A = distance.euclidean(eye[1], eye[5])
    B = distance.euclidean(eye[2], eye[4])
    C = distance.euclidean(eye[0], eye[3])
    ear_aspect_ratio = (A+B)/(2.0*C)
    return ear_aspect_ratio
cam = cv2.VideoCapture(0)
hfd = dlib.get_frontal_face_detector()
df = dlib.shape_predictor("shape_face_landmarks.dat") ##face landmarks
while True:
    _, frame = cam.read() ##input frame from camera
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) ##conversion of color to gray scale
    faces = hfd(gray)
    for face in faces:
        face_landmarks = df(gray, face)
        leftEye = []
        rightEye = []
        for n in range(36,42): ##left eye coordinates
            x = face_landmarks.part(n).x
            y = face_landmarks.part(n).y
            leftEye.append((x,y))
            next_point = n+1
            if n == 41:
                next_point = 36
            x2 = face_landmarks.part(next_point).x
            y2 = face_landmarks.part(next_point).y
            cv2.line(frame,(x,y),(x2,y2),(0,255,0),1)
    for n in range(42,48): ##right eye cordinates
        x = face_landmarks.part(n).x
        y = face_landmarks.part(n).y
        rightEye.append((x,y))
        next_point = n+1
        if n == 47:
            next_point = 42
        x2 = face_landmarks.part(next_point).x
        y2 = face_landmarks.part(next_point).y
        cv2.line(frame,(x,y),(x2,y2),(0,255,0),1)
    left_ear = calculate_EAR(leftEye) #calculate aspect ratio of Left
    right_ear = calculate_EAR(rightEye) #calculate aspect ratio of Right
    EAR = (left_ear+right_ear)/2
    EAR = round(EAR,2)
    if EAR<0.25: ##to check if aspect ratio is small
        cv2.putText(frame,"DROWSY",(20,100),cv2.FONT_HERSHEY_SIMPLEX,3,(0,0,255),4)
        cv2.putText(frame,"WAKE UP!!!!",(20,400),cv2.FONT_HERSHEY_SIMPLEX,2,(0,0,255),4)
        print("You are Drowsy!!!!")
        print(EAR)
    cv2.imshow("Drowsy Detection", frame)
    key = cv2.waitKey(1)
    if key == 27: ##escape key to break loop
        break
        cam.release()
cv2.destroyAllWindows() ##close all windows after exiting`