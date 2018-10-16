using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonkeyController : MonoBehaviour {

	// Use this for initialization
	public Material rimScaleMat;
	public float rimScaleStep;
	public Material noiseScaleMat;
	public float noiseScaleStep;
	private float rimScale;
	private float noiseScale;
	private float initialRimScale;
	private float initialNoiseScale;
	// Update is called once per frame
	private void Start() {
		rimScale = rimScaleMat.GetFloat("_Rimlightscale");
		initialRimScale = rimScale;
		noiseScale = noiseScaleMat.GetFloat("_Noisescale");
		initialNoiseScale = noiseScale;
	}
	void Update () {
		if (Input.GetKey(KeyCode.Alpha1)) {
			rimScale -= rimScaleStep;
			rimScale = Mathf.Max(0f, rimScale);
			rimScaleMat.SetFloat("_Rimlightscale", rimScale);
		}
		else if (Input.GetKey(KeyCode.Alpha2)) {
			rimScale += rimScaleStep;
			rimScaleMat.SetFloat("_Rimlightscale", rimScale);
		}
		else if (Input.GetKey(KeyCode.Alpha3)) {
			noiseScale -= noiseScaleStep;
			noiseScale = Mathf.Max(0f, noiseScale);
			noiseScaleMat.SetFloat("_Noisescale", noiseScale);
		}
		else if (Input.GetKey(KeyCode.Alpha4)) {
			noiseScale += noiseScaleStep;
			noiseScaleMat.SetFloat("_Noisescale", noiseScale);
		}
	}

	private void OnApplicationQuit() {
		rimScaleMat.SetFloat("_Rimlightscale", initialRimScale);
		noiseScaleMat.SetFloat("_Noisescale", initialNoiseScale);
	}
}
