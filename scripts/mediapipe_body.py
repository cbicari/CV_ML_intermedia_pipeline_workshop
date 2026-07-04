import mediapipe as mp 
import cv2

	

# Import needed modules from osc4py3
from osc4py3.as_eventloop import *
from osc4py3 import oscbuildparse

mp_pose = mp.solutions.pose

mp_draw = mp.solutions.drawing_utils

def send_pose_as_single_osc(landmarks):
    coordinates = []
    for landmark in landmarks:
        coordinates.extend([1.0 - float(landmark.x), 1.0 - float(landmark.y)])

    osc_msg = oscbuildparse.OSCMessage("/wek/inputs", None, coordinates)
    osc_send(osc_msg, "localhost")

def detection_context(dev_id=0):

    cap = cv2.VideoCapture(dev_id)
    with mp_pose.Pose(smooth_landmarks=True) as pose:
        while cap.isOpened():

            success, image = cap.read()
            if not success:
                print("Ignoring empty camera frame.")
                continue

            image.flags.writeable = False
            image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

            results = pose.process(image)

            if results.pose_landmarks:

                mp_draw.draw_landmarks(image, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)

                osc_process()
                send_pose_as_single_osc(results.pose_landmarks.landmark)

            image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
            image = cv2.flip(image, 1)
            cv2.imshow('frame', image)
            if cv2.waitKey(1) == ord('q') or cv2.getWindowProperty('frame', cv2.WND_PROP_VISIBLE) < 1:
                break

        cap.release()
        cv2.destroyAllWindows()
        osc_terminate()

if __name__ == '__main__':

    osc_startup()
    osc_udp_client("127.0.0.1", 9000, "localhost")
    detection_context()