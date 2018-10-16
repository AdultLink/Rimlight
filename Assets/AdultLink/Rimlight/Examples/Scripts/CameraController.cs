using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace AdultLink {
public class CameraController : MonoBehaviour {

	public float rotationSpeed = 10f;
	public float smoothTime = 0.3f;
	public Text nameText;
	public Text indexText;
	public Text descriptionText;
	public CameraPositions[] cameraPositions;
	public GameObject UIGO;
	private int positionIndex = 0;
	private Vector3 velocity = Vector3.zero;
	private Vector3 targetPos;
	private Vector3 targetRot;
	public Camera cam;
	public int sidescrollerIndex;

	public Transform playerTarget;

	void Start () {
		Cursor.visible = true;
		Cursor.lockState = CursorLockMode.None;
		setPosition();
		cam.transform.position = targetPos;
		cam.transform.rotation = Quaternion.Euler(targetRot);
	}
	private void Update() {

		if (Input.GetKeyDown(KeyCode.Z)) {
			UIGO.SetActive(!UIGO.activeInHierarchy);
		}

		//"GALLERY" MODE
		
		if (Input.GetKeyDown(KeyCode.LeftArrow)) {
			positionIndex -= 1;
			if (positionIndex < 0){
				positionIndex = cameraPositions.Length-1;
			}
			setPosition();
		}

		if (Input.GetKeyDown(KeyCode.RightArrow)) {
			positionIndex += 1;
			if (positionIndex >= cameraPositions.Length){
				positionIndex = 0;
			}
			setPosition();
		}

		if (positionIndex == sidescrollerIndex) {
			targetPos = playerTarget.position;
			targetRot = playerTarget.rotation.eulerAngles;
		}
		else {
			setPosition();
		}

		//SMOOTH MOVEMENT TO THE DESIRED POSITION
		cam.transform.position = Vector3.SmoothDamp(cam.transform.position, targetPos, ref velocity, smoothTime*Time.unscaledDeltaTime);
		cam.transform.rotation = Quaternion.RotateTowards(cam.transform.rotation, Quaternion.Euler(targetRot), Time.unscaledDeltaTime* rotationSpeed);

	}

	private void setPosition() {
			targetPos = cameraPositions[positionIndex].pos;
			targetRot = cameraPositions[positionIndex].rot;
			setInfo();
		}

		private void setInfo() {
			nameText.text = cameraPositions[positionIndex].name.ToString();
			indexText.text = (positionIndex+1).ToString() + "/" + cameraPositions.Length.ToString();
			descriptionText.text = cameraPositions[positionIndex].description.ToString();
		}
	}
}