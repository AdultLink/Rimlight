using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
public class FollowTarget : MonoBehaviour {

	// Use this for initialization
	public Transform target;
	private Vector3 offset;
	
	// Update is called once per frame
	private void Start() {
		offset = transform.position - target.position;
	}
	void Update () {
		transform.position = target.position + offset;
	}
}
}
