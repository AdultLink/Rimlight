using UnityEngine;
using System.Collections;

namespace AdultLink {
public class PlayerController : MonoBehaviour {

    public float speed;

    private Rigidbody rb;
    private Vector3 initialPosition;
    private float moveHorizontal;
    public float jumpStrength = 20f;
    public float raycastDistance = 0.05f;
    private float colliderRadius;

    void Start ()
    {
        initialPosition = transform.position;
        rb = GetComponent<Rigidbody>();
        colliderRadius = GetComponent<SphereCollider>().radius / 2f;
    }

    private void Update() {
        if (Input.GetKeyDown(KeyCode.R)) {
            resetPlayerPos();
        }
        if (Input.GetKeyDown(KeyCode.Space) && isGrounded()) {
            rb.AddForce(Vector3.up * jumpStrength, ForceMode.Impulse);
        }
        moveHorizontal = Input.GetAxis ("Horizontal");
    }

    void FixedUpdate ()
    {
        Debug.DrawLine(transform.position, transform.position - Vector3.up * (colliderRadius + raycastDistance), Color.red, 0f);
        Vector3 movement = new Vector3 (moveHorizontal, 0f, 0f);
        rb.AddForce(movement * speed);
    }

    private void resetPlayerPos() {
        transform.position = initialPosition;
        rb.velocity = Vector3.zero;
    }

    private bool isGrounded() {
        return Physics.Raycast(transform.position, -Vector3.up, colliderRadius + raycastDistance);
    }

    private void OnTriggerExit(Collider other) {
        if (other.gameObject.CompareTag("Despawner")) {
            resetPlayerPos();
        }
    }
}
}