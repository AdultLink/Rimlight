using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIController : MonoBehaviour {

	// Use this for initialization
	public Material[] mats;
	public Text onOffText;
	private float onOff = 1f;
	void Start () {
		setMaterials();
		onOffText.text = "ON";
		onOffText.color = Color.green;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.Q)) {
			toggleRimlight();
		}
	}

	private void toggleRimlight() {
		onOff = 1f - onOff;
		if (onOff == 1f) {
			onOffText.text = "ON";
			onOffText.color = Color.green;
		}
		else {
			onOffText.text = "OFF";
			onOffText.color = Color.red;
		}
		setMaterials();
	}
	private void setMaterials() {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetFloat("_Enablerimlight", onOff);
		}
	}

	private void OnApplicationQuit() {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetFloat("_Enablerimlight", 1f);
		}
	}
}
