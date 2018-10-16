using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseController : MonoBehaviour {

	// Use this for initialization
	private GameObject _lastHit = null;
	void Start () {
		
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		RaycastHit hit;
    	Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
    	Physics.Raycast(ray, out hit, 100f);
		
		if (hit.collider != null && hit.transform.gameObject.CompareTag("Highlightable")) {
			if (_lastHit == null)
			{
				_lastHit = hit.collider.gameObject;
				_lastHit.GetComponent<CharacterSelectionController>().select();
			}
			else if (_lastHit != hit.collider.gameObject)
			{
				_lastHit.GetComponent<CharacterSelectionController>().deSelect();
				_lastHit = hit.collider.gameObject;
				_lastHit.GetComponent<CharacterSelectionController>().select();
			}
        }
		else if (_lastHit != null)
		{
			_lastHit.GetComponent<CharacterSelectionController>().deSelect();
			_lastHit = null;
		}
	}
}
