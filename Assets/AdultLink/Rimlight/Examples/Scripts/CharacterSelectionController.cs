using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterSelectionController : MonoBehaviour {

	// Use this for initialization
	public Material[] mats;
	public GameObject _light;
	public Animator anim;

	public void select() {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetFloat("_Pulsate", 1f);
			mats[i].SetFloat("_Rimlightopacity", 1f);
		}
		_light.SetActive(true);
		anim.SetBool("Selected", true);
	}

	public void deSelect() {
		for (int i = 0; i < mats.Length; i++) {
			mats[i].SetFloat("_Pulsate", 0f);
			mats[i].SetFloat("_Rimlightopacity", 0f);
		}
		_light.SetActive(false);
		anim.SetBool("Selected", false);
	}
}
