using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class FollowTarget : MonoBehaviour {

	// Use this for initialization
	public Transform target;
	private Vector3 offset;
	public bool smooth = false;
	[Range(0f,1f)]
	public float smoothing;
	// Update is called once per frame
	private void Start() {
		offset = transform.position - target.position;
	}
	void Update () {
		if (smooth) {
			transform.position = Vector3.Lerp(transform.position, target.position + offset, smoothing);
		}
		else {
			transform.position = target.position + offset;
		}
	}
}
}
